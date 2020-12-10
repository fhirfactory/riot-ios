/*
 Copyright 2016 OpenMarket Ltd
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

#import "AttachmentsViewController.h"

#import "Riot-Swift.h"
#import <Messages/Messages.h>

@interface AttachmentsViewController ()
{
    // Observe kThemeServiceDidChangeThemeNotification to handle user interface theme change.
    id kThemeServiceDidChangeThemeNotificationObserver;
}

@end

@implementation AttachmentsViewController

#pragma mark -

- (void)finalizeInit
{
    [super finalizeInit];
    
    // Setup `MXKViewControllerHandling` properties.
    self.enableBarTintColorStatusChange = NO;
    self.rageShakeManager = [RageShakeManager sharedManager];
}

UIView *TagViewContainer;
PatientViewCellData *TagViewDetails;
NSLayoutConstraint *bottomConstraint;
bool viewHasAppeared = false;

- (void)viewDidLoad
{
    viewHasAppeared = false;
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.attachmentsCollection.accessibilityIdentifier =@"AttachmentsVC";
    
    // Observe user interface theme change.
    kThemeServiceDidChangeThemeNotificationObserver = [[NSNotificationCenter defaultCenter] addObserverForName:kThemeServiceDidChangeThemeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notif) {
        
        [self userInterfaceThemeDidChange];
        
    }];
    [self userInterfaceThemeDidChange];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (animated && TagViewContainer){
        [self animateInTagViewContainer];
    }
    viewHasAppeared = true;
}

- (void)viewDidDisappear:(BOOL)animated {
    [TagViewContainer removeFromSuperview];
    TagViewContainer = NULL;
}

- (void)displayAttachments:(NSArray *)attachmentArray focusOn:(NSString *)eventId {
    [super displayAttachments:attachmentArray focusOn:eventId];
    [self loadTagInfo];
}

- (void)refreshCurrentVisibleCell
{
    struct objc_super superInfo = {
        self,
        [self superclass]
    };
    ((void (*)(struct objc_super *, SEL))objc_msgSendSuper)(&superInfo,@selector(refreshCurrentVisibleCell));
    [self loadTagInfo];
}

UIButton *ShowMoreButton;
UIButton *ShowLessButton;

- (void)addTagViewContainer
{
    if (!TagViewContainer) {
        TagViewContainer = [UIView new];
        [TagViewContainer setAlpha:0.0];
    
        [self.view addSubview:TagViewContainer];
        UILayoutGuide *guide;
        if (@available(iOS 11, *)) {
            guide = self.view.safeAreaLayoutGuide;
        } else {
            guide = self.view.layoutMarginsGuide;
        }
        
        [self.view addConstraint:[TagViewContainer.bottomAnchor constraintEqualToAnchor:guide.bottomAnchor]];
        [TagViewContainer addConstraint:[TagViewContainer.heightAnchor constraintEqualToConstant:100]];
        [self.view addConstraint:[TagViewContainer.leftAnchor constraintEqualToAnchor:self.view.leftAnchor]];
        [self.view addConstraint:[TagViewContainer.rightAnchor constraintEqualToAnchor:self.view.rightAnchor]];
        TagViewContainer.translatesAutoresizingMaskIntoConstraints = NO;
    } else {
        [TagViewContainer setAlpha:0.0];
    }
}

UITapGestureRecognizer *TagGestureRecognizer;
UILongPressGestureRecognizer *TagLongPressRecognizer;

- (void)loadTagInfo
{
    
    NSInteger currentIdx = [[self valueForKey:@"currentVisibleItemIndex"] integerValue];
    if (currentIdx != NSNotFound && !TagViewContainer) {
        MXKAttachment *attachment = self.attachments[currentIdx];
        NSString *contentURL = attachment.contentURL;
        
        [self hideTag];
        
        [[Services ImageTagDataService] LookupTagInfoForObjcWithURL:contentURL andHandler:^(NSArray *tagData) {
            
            isShowingDetail = false;
            
            TagViewDetails = [PatientViewCellObjectiveC getPatientViewCellForTagData:tagData];
            [self tryDisplayTag];
        }];
    }
    
}

- (void)tryDisplayTag{
    if (TagViewDetails && !(TagViewContainer)){
        [self addTagViewContainer];
        
        UIView *TagView = TagViewDetails.returnView;
        [TagView sizeToFit];
        
        for (UIView *view in TagViewContainer.subviews) {
            [view removeFromSuperview];
        }
        [TagViewContainer addSubview:TagView];
        [TagViewContainer setAlpha:0.0];
        [TagViewContainer setOpaque:NO];
        
        if (TagViewDetails.includesPatientDetails){
    //                ShowMoreButton = [UIButton new];
    //
    //                if (@available(iOS 13.0, *)) {
    //                    [ShowMoreButton setImage:[UIImage systemImageNamed:@"chevron.up"] forState:UIControlStateNormal];
    //                } else {
    //                    [ShowMoreButton setImage:[UIImage imageNamed:@"chevron.up"] forState:UIControlStateNormal];
    //                }
    //                [ShowMoreButton setTitle: NSLocalizedStringFromTable(@"show_more", @"Vector", NULL) forState:UIControlStateNormal];
    //                [ShowMoreButton sizeToFit];
    //                [TagViewContainer addSubview:ShowMoreButton];
    //                [ShowMoreButton addTarget:self action:@selector(tagShowMoreButton) forControlEvents:UIControlEventTouchUpInside];
    //                [ThemeService.shared.theme applyStyleOnButton:ShowMoreButton];
    //                ShowMoreButton.translatesAutoresizingMaskIntoConstraints = false;
    //
    //                ShowLessButton = [UIButton new];
    //                if (@available(iOS 13.0, *)) {
    //                    [ShowLessButton setImage:[UIImage systemImageNamed:@"chevron.down"] forState:UIControlStateNormal];
    //                } else {
    //                    [ShowLessButton setImage:[UIImage imageNamed:@"chevron.down"] forState:UIControlStateNormal];
    //                }
    //                [ShowLessButton setTitle: NSLocalizedStringFromTable(@"show_less", @"Vector", NULL) forState:UIControlStateNormal];
    //                [ShowLessButton sizeToFit];
    //                [TagViewContainer addSubview:ShowLessButton];
    //                [ShowLessButton addTarget:self action:@selector(tagShowLessButton) forControlEvents:UIControlEventTouchUpInside];
    //                [ThemeService.shared.theme applyStyleOnButton:ShowLessButton];
    //                [ShowLessButton setAlpha:0];
    //                ShowLessButton.translatesAutoresizingMaskIntoConstraints = false;
            
            //bottomConstraint = [TagView.bottomAnchor constraintEqualToAnchor:TagViewContainer.bottomAnchor constant:TagViewDetails.otherViews.frame.size.height];
            bottomConstraint = [TagViewDetails.patientDetailsView.bottomAnchor constraintEqualToAnchor:TagViewContainer.bottomAnchor constant:0.0];
            [TagViewContainer addConstraint:bottomConstraint];
            [TagViewContainer addConstraint:[TagView.leftAnchor constraintEqualToAnchor:TagViewContainer.leftAnchor]];
            [TagViewContainer addConstraint:[TagView.rightAnchor constraintEqualToAnchor:TagViewContainer.rightAnchor]];
            TagView.translatesAutoresizingMaskIntoConstraints = NO;
            [TagView sizeToFit];
            [TagView setClipsToBounds:YES];
            
            [TagViewDetails.otherViews setAlpha:0];
            
            [TagViewContainer setContentMode:UIViewContentModeCenter];
            [TagViewContainer setAutoresizesSubviews:NO];
            
    //                [TagViewContainer addConstraint:[ShowMoreButton.topAnchor constraintEqualToAnchor:TagViewDetails.patientDetailsView.topAnchor]];
    //                [TagViewContainer addConstraint:[ShowMoreButton.rightAnchor constraintEqualToAnchor:TagViewDetails.patientDetailsView.rightAnchor]];
    //
    //                [TagViewContainer addConstraint:[ShowLessButton.topAnchor constraintEqualToAnchor:TagViewDetails.descriptionView.topAnchor]];
    //                [TagViewContainer addConstraint:[ShowLessButton.rightAnchor constraintEqualToAnchor:TagViewDetails.descriptionView.rightAnchor]];
            
            if (TagGestureRecognizer) {
                [[self view] removeGestureRecognizer:TagGestureRecognizer];
                TagGestureRecognizer = NULL;
            }
            
            if (TagLongPressRecognizer) {
                [[self view] removeGestureRecognizer:TagLongPressRecognizer];
                TagLongPressRecognizer = NULL;
            }
            
            TagGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGestureRecognition:)];
            
            TagLongPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleGestureRecognition:)];
            
            [TagLongPressRecognizer setCancelsTouchesInView:NO];
            [[self view] addGestureRecognizer:TagLongPressRecognizer];
            [[self view] addGestureRecognizer:TagGestureRecognizer];
            
            
            
        }
        [self.view layoutSubviews];
        
        if (viewHasAppeared){
            [self animateInTagViewContainer];
        }
    }
}

- (void)animateInTagViewContainer{
    /// this is all a little weird. In essense, if iOS the layout of a view is not calculated, iOS won't bother properly performing an animation (because for all the phone knows, the view may be off-screen, or behind something). Hence, we need to call layoutIfNeeded before trying to animate our TagViewContainer.
    /// However, it seems (I don't know this for sure) like layoutIfNeeded (or at least some aspect of the drawing stack) is actually asynchronous / on a different thread. Resultantly, if we just call layoutIfNeeded, then go on to perform our animation, we find that the animation is ignored, as the correct layout / frame for the TagViewContainer has not yet been calculated.
    
    [UIView animateWithDuration:0.05 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 animations:^{
            [TagViewContainer setAlpha:1];
        }];
    }];
}

NSMutableDictionary *cellGestureRecognizers;
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!cellGestureRecognizers) {
        cellGestureRecognizers = [NSMutableDictionary new];
    }
    UICollectionViewCell *returnCell = [super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    for (UIGestureRecognizer *rec in returnCell.gestureRecognizers){
        [rec setEnabled:NO];
        if ([rec isKindOfClass:UITapGestureRecognizer.class]) {
            [cellGestureRecognizers setObject:rec forKey:[NSNumber numberWithLong:indexPath.row]];
        }
    }
    return returnCell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self hideTag];
}

- (void)hideTag
{
    NSInteger tempIndex = [[self valueForKey:@"currentVisibleItemIndex"] integerValue];
    if (TagViewDetails && TagViewContainer) {
        [UIView animateWithDuration:0.4 animations:^{
            [TagViewContainer setAlpha:0.0];
            TagViewDetails = NULL;
        } completion:^(BOOL finished) {
            [TagViewContainer removeFromSuperview];
            TagViewContainer = NULL;
            NSInteger currentIdx = [[self valueForKey:@"currentVisibleItemIndex"] integerValue];
            //display the tag if we've switched attachments
            if (tempIndex != currentIdx) {
                [self loadTagInfo];
            }
        }];
    }
}

- (void)tagShowMoreButton
{
    isShowingDetail = true;
    if (TagViewDetails && TagViewDetails.includesPatientDetails) {
        [bottomConstraint setConstant:-TagViewDetails.otherViews.frame.size.height];
        [UIView animateWithDuration:0.2 animations:^{
            [TagViewDetails.otherViews setAlpha:1.0];
            [ShowMoreButton setAlpha:0];
            [TagViewContainer layoutIfNeeded];
            [TagViewContainer setNeedsDisplay];
            [ShowLessButton setAlpha:1.0];
            [TagViewContainer setAlpha:0.9];
        } completion:^(BOOL finished) {
            [TagViewContainer layoutIfNeeded];
            [TagViewContainer setNeedsDisplay];
            [TagViewContainer layoutSubviews];
            [ShowLessButton setUserInteractionEnabled:YES];
        }];
    }
}

- (void)tagShowLessButton
{
    isShowingDetail = false;
    if (TagViewDetails && TagViewDetails.includesPatientDetails) {
        [bottomConstraint setConstant:0];
        [UIView animateWithDuration:0.2 animations:^{
            [TagViewDetails.otherViews setAlpha:0.0];
            [ShowMoreButton setAlpha:1.0];
            [ShowLessButton setAlpha:0.0];
            [ShowMoreButton setUserInteractionEnabled:YES];
            [TagViewContainer setAlpha:1.0];
            [TagViewContainer layoutIfNeeded];
        } completion:^(BOOL finished) {
            [TagViewContainer layoutIfNeeded];
            [TagViewContainer setNeedsDisplay];
            [TagViewContainer layoutSubviews];
        }];
    }
}

bool isShowingDetail = false;
//MARK:- Pass gestures to the underlying MXKAttachmentViewController
//It's not unlikely that at some point in the future this function will begin to cause issues.
- (void)handleGestureRecognition:(UIGestureRecognizer*) GestureRecognizer
{
    NSInteger currentIdx = [[self valueForKey:@"currentVisibleItemIndex"] integerValue];
    UIGestureRecognizer *cellGestureRecognizer = [cellGestureRecognizers objectForKey:[NSNumber numberWithLong:currentIdx]];
    CGPoint location = (isShowingDetail ? [GestureRecognizer locationInView:[TagViewContainer.subviews firstObject]] : [GestureRecognizer locationInView:TagViewContainer]);
    if ((isShowingDetail && [self point:location IsInRectangle:[TagViewContainer.subviews firstObject].bounds]) || (!isShowingDetail && [self point:location IsInRectangle:TagViewContainer.bounds])){
        if ([GestureRecognizer isKindOfClass:UITapGestureRecognizer.class]){
            if (isShowingDetail) {
                [self tagShowLessButton];
            } else {
                [self tagShowMoreButton];
            }
        }
    } else {
        CGPoint LocationInCell = [GestureRecognizer locationInView:cellGestureRecognizer.view];
        if ([self point:LocationInCell IsInRectangle:cellGestureRecognizer.view.bounds]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
            if ([GestureRecognizer isKindOfClass:UITapGestureRecognizer.class]){
                [super performSelector:@selector(onCollectionViewCellTap:) withObject:cellGestureRecognizer]; //this selector does exist, as does the selector below.
                ///It's a little dangerous to directly performselector, as the name of the selector may change in MatrixKit, and this would lead to an annoying-to-diagnose crash.
                ///A solution to this, would be getting the selector on the base gesture recognizers in MatrixKit. This could be done by getValueForKey'ing targets (or it might be actions) on the gesture recognizer, which would return a NSObject with an attached target (NSObject) and selector (SEL), from which we could then extract the target and selector (with get_IVar for the selector (as otherwise you've got to convert an ARC managed pointer to a selector, which isn't allowed), and a normal getValueForKey for the target), which would ensure that no matter what changes are made to MatrixKit, this code continutes to work as expected; HOWEVER, doing this requires simply moving the reliance to one on Apple's private implementation of UIGestureRecognizers, and again, as private APIs are used doing this, the app could be banned from the app store as a result.
                ///So, putting this reliance on the MatrixKit Private APIs remaining the same was chosen over utilizing Apple's private APIs -- but it's reasonably likely that this will eventually become a problem.
            } else if ([GestureRecognizer isKindOfClass:UILongPressGestureRecognizer.class]) {
                
                [super performSelector:@selector(onCollectionViewCellLongPress:) withObject:GestureRecognizer];
            }
#pragma clang diagnostic pop
        }
    }
}

- (bool)point:(CGPoint) point IsInRectangle:(CGRect)rect {
    CGFloat x1 = rect.origin.x;
    CGFloat y1 = rect.origin.y;
    return point.x >= x1 && point.y >= y1 && point.x <= x1 + rect.size.width && point.y <= y1 + rect.size.height;
}

- (void)userInterfaceThemeDidChange
{
    [ThemeService.shared.theme applyStyleOnNavigationBar:self.navigationController.navigationBar];

    self.view.backgroundColor = ThemeService.shared.theme.backgroundColor;
    self.activityIndicator.backgroundColor = ThemeService.shared.theme.overlayBackgroundColor;
    
    self.backButton.tintColor = ThemeService.shared.theme.tintColor;

    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return ThemeService.shared.theme.statusBarStyle;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // Screen tracking
    [[Analytics sharedInstance] trackScreen:@"AttachmentsViewer"];
}

- (void)destroy
{
    [super destroy];
    
    if (kThemeServiceDidChangeThemeNotificationObserver)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:kThemeServiceDidChangeThemeNotificationObserver];
        kThemeServiceDidChangeThemeNotificationObserver = nil;
    }
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    BOOL animated = flag && !self.presentingViewController.presentingViewController;
    [super dismissViewControllerAnimated:animated completion:completion];
}

@end
