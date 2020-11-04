/*
 Copyright 2015 OpenMarket Ltd
 Copyright 2017 Vector Creations Ltd
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "SegmentedViewController.h"

#import "ThemeService.h"

#ifdef IS_SHARE_EXTENSION
#import "RiotShareExtension-Swift.h"
#else
#import "Riot-Swift.h"
#endif

@implementation BadgeData
-(instancetype)init{
    _BadgeColour = UIColor.redColor;
    _BadgeNumber = 0;
    _ShouldDisplay = NO;
    return self;
}
-(instancetype)initWithColour:(UIColor*)Colour andBadgeNumber:(long)Number andShouldDisplay:(BOOL)ShouldDisplay{
    _BadgeColour = Colour;
    _BadgeNumber = Number;
    _ShouldDisplay = ShouldDisplay;
    return self;
}
@end

@interface SegmentedViewController ()
{
    // Tell whether the segmented view is appeared (see viewWillAppear/viewWillDisappear).
    BOOL isViewAppeared;
    
    // list of displayed UIViewControllers
    NSArray* viewControllers;
    
    // The constraints of the displayed viewController
    NSLayoutConstraint *displayedVCTopConstraint;
    NSLayoutConstraint *displayedVCLeftConstraint;
    NSLayoutConstraint *displayedVCWidthConstraint;
    NSLayoutConstraint *displayedVCHeightConstraint;
    
    // list of NSString
    NSArray* sectionTitles;
    
    // list of section labels
    NSArray* sectionLabels;
    
    //list of badges
    NSMutableArray<BadgeData*> *badgeDataArray;
    NSMutableArray<UIView*> *badgeViews;
    
    // the selected marker view
    UIView* selectedMarkerView;
    NSLayoutConstraint *leftMarkerViewConstraint;
    
    // Observe kThemeServiceDidChangeThemeNotification to handle user interface theme change.
    id kThemeServiceDidChangeThemeNotificationObserver;
}

@end

@implementation SegmentedViewController

#pragma mark - Class methods

+ (UINib *)nib
{
    return [UINib nibWithNibName:NSStringFromClass([SegmentedViewController class])
                          bundle:[NSBundle bundleForClass:[SegmentedViewController class]]];
}

+ (instancetype)segmentedViewController
{
    return [[[self class] alloc] initWithNibName:NSStringFromClass([SegmentedViewController class])
                                          bundle:[NSBundle bundleForClass:[SegmentedViewController class]]];
}

/**
 init the segmentedViewController with a list of UIViewControllers.
 @param titles the section tiles
 @param viewControllers the list of viewControllers to display.
 @param defaultSelected index of the default selected UIViewController in the list.
 */
- (void)initWithTitles:(NSArray*)titles viewControllers:(NSArray*)someViewControllers defaultSelected:(NSUInteger)defaultSelected
{
    viewControllers = someViewControllers;
    sectionTitles = titles;
    _selectedIndex = defaultSelected;
    NSMutableArray<NSNumber*> *visibleMutable = [NSMutableArray new];
    NSMutableArray<BadgeData*> *badgeMutable = [NSMutableArray new];
    for (int i = 0; i < someViewControllers.count; i++){
        [visibleMutable addObject:@(YES)];
        [badgeMutable addObject:[BadgeData new]];
    }
    _Visible = visibleMutable;
    badgeDataArray = badgeMutable;
}

- (void)destroy
{
    for (id viewController in viewControllers)
    {
        if ([viewController respondsToSelector:@selector(destroy)])
        {
            [viewController destroy];
        }
    }
    viewControllers = nil;
    sectionTitles = nil;
    
    sectionLabels = nil;
    
    if (selectedMarkerView)
    {
        [selectedMarkerView removeFromSuperview];
        selectedMarkerView = nil;
    }
    
    if (kThemeServiceDidChangeThemeNotificationObserver)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:kThemeServiceDidChangeThemeNotificationObserver];
        kThemeServiceDidChangeThemeNotificationObserver = nil;
    }
    
    [super destroy];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    if (_selectedIndex != selectedIndex)
    {
        _selectedIndex = selectedIndex;
        [self displaySelectedViewController];
    }
}

- (NSArray<UIViewController *> *)viewControllers
{
    return viewControllers;
}

- (void)setSectionHeaderTintColor:(UIColor *)sectionHeaderTintColor
{
    if (_sectionHeaderTintColor != sectionHeaderTintColor)
    {
        _sectionHeaderTintColor = sectionHeaderTintColor;
        
        if (selectedMarkerView)
        {
            selectedMarkerView.backgroundColor = sectionHeaderTintColor;
        }
        
        for (UILabel *label in sectionLabels)
        {
            label.textColor = sectionHeaderTintColor;
        }
    }
}

#pragma mark -

- (void)finalizeInit
{
    [super finalizeInit];
    
    // Setup `MXKViewControllerHandling` properties
    self.enableBarTintColorStatusChange = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Check whether the view controller has been pushed via storyboard
    if (!self.viewControllerContainer)
    {
        // Instantiate view controller objects
        [[[self class] nib] instantiateWithOwner:self options:nil];
    }

    // Adjust Top
    [NSLayoutConstraint deactivateConstraints:@[self.selectionContainerTopConstraint]];
    
    // it is not possible to define a constraint to the topLayoutGuide in the xib editor
    // so do it in the code ..
    self.selectionContainerTopConstraint = [NSLayoutConstraint constraintWithItem:self.topLayoutGuide
                                                                  attribute:NSLayoutAttributeBottom
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.selectionContainer
                                                                  attribute:NSLayoutAttributeTop
                                                                 multiplier:1.0f
                                                                   constant:0.0f];
    
    [NSLayoutConstraint activateConstraints:@[self.selectionContainerTopConstraint]];
    
    [self createSegmentedViews];
    
    // Observe user interface theme change.
    kThemeServiceDidChangeThemeNotificationObserver = [[NSNotificationCenter defaultCenter] addObserverForName:kThemeServiceDidChangeThemeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notif) {
        
        [self userInterfaceThemeDidChange];
        
    }];
    [self userInterfaceThemeDidChange];
}

- (void)userInterfaceThemeDidChange
{
    [ThemeService.shared.theme applyStyleOnNavigationBar:self.navigationController.navigationBar];

    self.activityIndicator.backgroundColor = ThemeService.shared.theme.overlayBackgroundColor;
    
    self.view.backgroundColor = ThemeService.shared.theme.backgroundColor;
    
    self.sectionHeaderTintColor = ThemeService.shared.theme.tintColor;

    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return ThemeService.shared.theme.statusBarStyle;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self userInterfaceThemeDidChange];

    if (_selectedViewController)
    {
        // Make iOS invoke child viewWillAppear
        [_selectedViewController beginAppearanceTransition:YES animated:animated];
    }
    
    isViewAppeared = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_selectedViewController)
    {
        // Make iOS invoke child viewWillDisappear
        [_selectedViewController beginAppearanceTransition:NO animated:animated];
    }
    
    isViewAppeared = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_selectedViewController)
    {
        // Make iOS invoke child viewDidAppear
        [_selectedViewController endAppearanceTransition];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (_selectedViewController)
    {
        // Make iOS invoke child viewDidDisappear
        [_selectedViewController endAppearanceTransition];
    }
}

- (void)createSegmentedViews
{
    if (!self.selectionContainer){
        return; //Don't allow the view to be updated if it hasn't loaded
    }
    
    //clear the selection area
    if (_selectionContainer.subviews.count){
        NSArray<UIView *> *subviews = _selectionContainer.subviews;
        for (UIView* view in subviews) {
            [view removeFromSuperview];
        }
    }
    
    NSMutableArray* labels = [[NSMutableArray alloc] init];
    
    NSUInteger count = 0;
    
    for (int i = 0; i < viewControllers.count; i++) {
        if ([_Visible[i] isEqual:@(YES)]){
            count += 1;
        }
    }
    
    for (NSUInteger index = 0; index < viewControllers.count; index++)
    {
        if ([_Visible[index] isEqual:@(YES)]){
            // create programmatically each label
            UILabel *label = [[UILabel alloc] init];
            
            label.text = sectionTitles[index];
            label.font = [UIFont systemFontOfSize:15];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = _sectionHeaderTintColor;
            label.backgroundColor = [UIColor clearColor];
            label.accessibilityIdentifier = [NSString stringWithFormat:@"SegmentedVCSectionLabel%tu", index];
            
            // the constraint defines the label frame
            // so ignore any autolayout stuff
            [label setTranslatesAutoresizingMaskIntoConstraints:NO];
            
            // add the label before setting the constraints
            [self.selectionContainer addSubview:label];
        
            NSLayoutConstraint *leftConstraint;
            if (labels.count)
            {
                leftConstraint = [NSLayoutConstraint constraintWithItem:label
                                                              attribute:NSLayoutAttributeLeading
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:labels[labels.count - 1]
                                                              attribute:NSLayoutAttributeTrailing
                                                             multiplier:1.0
                                                               constant:0];
            }
            else
            {
                leftConstraint = [NSLayoutConstraint constraintWithItem:label
                                             attribute:NSLayoutAttributeLeading
                                             relatedBy:NSLayoutRelationEqual
                                                toItem:self.selectionContainer
                                             attribute:NSLayoutAttributeLeading
                                            multiplier:1.0
                                              constant:0];
            }
            
            NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:label
                                                                               attribute:NSLayoutAttributeWidth
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:self.selectionContainer
                                                                               attribute:NSLayoutAttributeWidth
                                                                              multiplier:1.0 / count
                                                                                constant:0];
            
            NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:label
                                                                             attribute:NSLayoutAttributeTop
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self.selectionContainer
                                                                             attribute:NSLayoutAttributeTop
                                                                            multiplier:1.0
                                                                              constant:0];
            
            
            
            NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:label
                                                                                attribute:NSLayoutAttributeHeight
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:self.selectionContainer
                                                                                attribute:NSLayoutAttributeHeight
                                                                               multiplier:1.0
                                                                                 constant:0];
            
            
            // set the constraints
            [NSLayoutConstraint activateConstraints:@[leftConstraint, rightConstraint, topConstraint, heightConstraint]];
            
            UITapGestureRecognizer *labelTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onLabelTouch:)];
            [labelTapGesture setNumberOfTouchesRequired:1];
            [labelTapGesture setNumberOfTapsRequired:1];
            label.userInteractionEnabled = YES;
            [label addGestureRecognizer:labelTapGesture];
                
            [labels addObject:label];
        }
    }
    
    sectionLabels = labels;
    
    [self addSelectedMarkerView];
    
    [self displaySelectedViewController];
    
    [self drawBadges];
}

- (void)drawBadges{
    NSUInteger count = 0;
    @synchronized (badgeViews) {
        
        if (!self.selectionContainer){
            return;
        }
        
        for (long i = 0; i < badgeViews.count; i++){
            if (badgeViews[i]){
                [badgeViews[i] removeFromSuperview];
            }
        }
        
        for (int i = 0; i < viewControllers.count; i++) {
            if ([_Visible[i] isEqual:@(YES)]){
                count += 1;
            }
        }
        
        long displaying = 0;
        for (long i = 0; i < viewControllers.count; i++){
            BadgeData *bd = badgeDataArray[i];
            if ([_Visible[i] isEqual:@(YES)]){
                displaying++;
            }
            if (bd.ShouldDisplay && [_Visible[i] isEqual:@(YES)]){
                
                UIView *badge = [UIView new];
                UILabel *label = [UILabel new];
                label.text = [[NSString alloc] initWithFormat:@"%ld", (long)bd.BadgeNumber];
                label.textAlignment = NSTextAlignmentCenter;
                [label sizeToFit];
                NSLayoutConstraint *labelCenterX = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:badge attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
                NSLayoutConstraint *labelCenterY = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:badge attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
                
                [badge addSubview:label];
                label.translatesAutoresizingMaskIntoConstraints = NO;
                [NSLayoutConstraint activateConstraints:@[labelCenterX, labelCenterY]];
                
                
                badge.backgroundColor = bd.BadgeColour;
                NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:badge
                                                                                   attribute:NSLayoutAttributeCenterX
                                                                                   relatedBy:NSLayoutRelationEqual
                                                                                      toItem:self.selectionContainer
                                                                                   attribute:NSLayoutAttributeTrailing
                                                                                  multiplier:(1.0 / count) * (displaying)
                                                                                    constant:-15];
                NSLayoutConstraint *yPosConstraint = [NSLayoutConstraint constraintWithItem:badge attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.selectionContainer attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
                NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:badge attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:20.0];
                NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:badge attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:label attribute:NSLayoutAttributeWidth multiplier:1.0 constant:10.0];
                widthConstraint.priority = 999;
                NSLayoutConstraint *minWidthConstraint = [NSLayoutConstraint constraintWithItem:badge attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:20.0];
                
                [self.selectionContainer addSubview:badge];
                [NSLayoutConstraint activateConstraints:@[rightConstraint, yPosConstraint, heightConstraint, widthConstraint, minWidthConstraint]];
                badge.translatesAutoresizingMaskIntoConstraints = NO; //https://www.innoq.com/en/blog/ios-auto-layout-problem/
                [badge layoutIfNeeded];
                badge.layer.cornerRadius = badge.frame.size.height / 2;
                [badge setUserInteractionEnabled:NO];
                [label setUserInteractionEnabled:NO];
                
                badgeViews[i] = badge;
            }
        }
    }
}

- (void)setBadge:(BadgeData*)badge forLocation:(long)location{
    badgeDataArray[location] = badge;
}

- (void)addSelectedMarkerView
{
    // Sanity check
    NSAssert(sectionLabels.count, @"[SegmentedViewController] addSelectedMarkerView failed - At least one view controller is required");

    // create the selected marker view
    selectedMarkerView = [[UIView alloc] init];
    selectedMarkerView.backgroundColor = _sectionHeaderTintColor;
    [selectedMarkerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.selectionContainer addSubview:selectedMarkerView];
    
    leftMarkerViewConstraint = [NSLayoutConstraint constraintWithItem:selectedMarkerView
                                                            attribute:NSLayoutAttributeLeading
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:sectionLabels[_selectedIndex]
                                                            attribute:NSLayoutAttributeLeading
                                                           multiplier:1.0
                                                             constant:0];
    
    
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:selectedMarkerView
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.selectionContainer
                                                                       attribute:NSLayoutAttributeWidth
                                                                      multiplier:1.0 / sectionLabels.count
                                                                        constant:0];
    
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:selectedMarkerView
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.selectionContainer
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0
                                                                         constant:0];
    
    
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:selectedMarkerView
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0
                                                                         constant:3];
    
    // set the constraints
    [NSLayoutConstraint activateConstraints:@[leftMarkerViewConstraint, widthConstraint, bottomConstraint, heightConstraint]];
}

- (long)getRealIndexFor:(long)baseIndex{
    long actualIndex = 0;
    //if (actualIndex != _selectedIndex)
    {
        long tempIndex = -1;
        for (; actualIndex < viewControllers.count; actualIndex++){
            if ([_Visible[actualIndex] isEqual:@(YES)]){
                tempIndex++;
                if (tempIndex == _selectedIndex){
                    break;
                }
            }
        }
    }
    return actualIndex;
}

- (long)getFakeIndexFor:(long)realIndex{
    long index = -1;
    for (long i = 0; i <= realIndex; i++){
        if ([_Visible[i] isEqual:@(YES)]){
            index++;
        }
    }
    return index;
}

- (void)displaySelectedViewController
{
    // Sanity check
    NSAssert(sectionLabels.count, @"[SegmentedViewController] displaySelectedViewController failed - At least one view controller is required");

    if (_selectedViewController)
    {
        NSUInteger index = [viewControllers indexOfObject:_selectedViewController];
        
        if (index != NSNotFound)
        {
            UILabel* label = sectionLabels[[self getFakeIndexFor:index]];
            label.font = [UIFont systemFontOfSize:15];
        }
        
        [_selectedViewController willMoveToParentViewController:nil];
        
        [_selectedViewController.view removeFromSuperview];
        [_selectedViewController removeFromParentViewController];
        
        if (displayedVCTopConstraint){
            [NSLayoutConstraint deactivateConstraints:@[displayedVCTopConstraint, displayedVCLeftConstraint, displayedVCWidthConstraint, displayedVCHeightConstraint]];
        }
    }
    
    UILabel* label = sectionLabels[_selectedIndex];
    label.font = [UIFont boldSystemFontOfSize:16];

    // update the marker view position
    [NSLayoutConstraint deactivateConstraints:@[leftMarkerViewConstraint]];

    leftMarkerViewConstraint = [NSLayoutConstraint constraintWithItem:selectedMarkerView
                                                            attribute:NSLayoutAttributeLeading
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:sectionLabels[_selectedIndex]
                                                            attribute:NSLayoutAttributeLeading
                                                           multiplier:1.0
                                                             constant:0];

    [NSLayoutConstraint activateConstraints:@[leftMarkerViewConstraint]];
    
    // Set the new selected view controller
    _selectedViewController = viewControllers[[self getRealIndexFor:_selectedIndex]];

    // Make iOS invoke selectedViewController viewWillAppear when the segmented view is already visible
    if (isViewAppeared)
    {
        [_selectedViewController beginAppearanceTransition:YES animated:YES];
    }

    [self addChildViewController:_selectedViewController];
    
    [_selectedViewController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.viewControllerContainer addSubview:_selectedViewController.view];
    
    
    displayedVCTopConstraint = [NSLayoutConstraint constraintWithItem:_selectedViewController.view
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.viewControllerContainer
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1.0f
                                                             constant:0.0f];
    
    displayedVCLeftConstraint = [NSLayoutConstraint constraintWithItem:_selectedViewController.view
                                                             attribute:NSLayoutAttributeLeading
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.viewControllerContainer
                                                             attribute:NSLayoutAttributeLeading
                                                            multiplier:1.0f
                                                              constant:0.0f];
    
    displayedVCWidthConstraint = [NSLayoutConstraint constraintWithItem:_selectedViewController.view
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.viewControllerContainer
                                                                        attribute:NSLayoutAttributeWidth
                                                                       multiplier:1.0
                                                                         constant:0];
    
    displayedVCHeightConstraint = [NSLayoutConstraint constraintWithItem:_selectedViewController.view
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.viewControllerContainer
                                                              attribute:NSLayoutAttributeHeight
                                                             multiplier:1.0
                                                               constant:0];
    
    [NSLayoutConstraint activateConstraints:@[displayedVCTopConstraint, displayedVCLeftConstraint, displayedVCWidthConstraint, displayedVCHeightConstraint]];
    
    [_selectedViewController didMoveToParentViewController:self];
    
    // Make iOS invoke selectedViewController viewDidAppear when the segmented view is already visible
    if (isViewAppeared)
    {
        [_selectedViewController endAppearanceTransition];
    }
}

#pragma mark - Search

- (void)showSearch:(BOOL)animated
{
    [super showSearch:animated];

    // Show the tabs header
    if (animated)
    {
        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseIn
                         animations:^{

                             self.selectionContainerHeightConstraint.constant = 44;
                             [self.view layoutIfNeeded];
                         }
                         completion:^(BOOL finished){
                         }];
    }
    else
    {
        self.selectionContainerHeightConstraint.constant = 44;
        [self.view layoutIfNeeded];
    }
}

- (void)hideSearch:(BOOL)animated
{
    [super hideSearch:animated];

    // Hide the tabs header
    if (animated)
    {
        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseIn
                         animations:^{

                             self.selectionContainerHeightConstraint.constant = 0;
                             [self.view layoutIfNeeded];
                         }
                         completion:^(BOOL finished) {
                             // Go back to the main tab
                             // Do it at the end of the animation when the tabs header of the SegmentedVC is hidden
                             // so that the user cannot see the selection bar of this header moving
                             self.selectedIndex = 0;
                             self.selectedViewController.view.hidden = NO;
                         }];
    }
    else
    {
        self.selectionContainerHeightConstraint.constant = 0;
        [self.view layoutIfNeeded];

        // Go back to the recents tab
        self.selectedIndex = 0;
        self.selectedViewController.view.hidden = NO;
    }
}

#pragma mark - touch event

- (void)onLabelTouch:(UIGestureRecognizer*)gestureRecognizer
{
    NSUInteger pos = [sectionLabels indexOfObject:gestureRecognizer.view];
    
    // check if there is an update before triggering anything
    if ((pos != NSNotFound) && (_selectedIndex != pos))
    {
        // update the selected index
        self.selectedIndex = pos;
    }
}

@end
