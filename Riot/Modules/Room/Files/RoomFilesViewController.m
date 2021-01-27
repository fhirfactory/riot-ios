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

#import "RoomFilesViewController.h"

#import "FilesSearchTableViewCell.h"

#import "Riot-Swift.h"

#import "AttachmentsViewController.h"

@interface RoomFilesViewController ()
{
    /**
     Observe kThemeServiceDidChangeThemeNotification to handle user interface theme change.
     */
    id kThemeServiceDidChangeThemeNotificationObserver;
}

@end

@implementation RoomFilesViewController

#pragma mark -

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.autoJoinInvitedRoom = NO;
    }
    [self setIsInGalleryContext:NO];
    return self;
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.autoJoinInvitedRoom = NO;
    }
    [self setIsInGalleryContext:NO];
    return self;
}

#pragma mark -

- (void)finalizeInit
{
    [super finalizeInit];
    
    // Setup `MXKViewControllerHandling` properties
    self.enableBarTintColorStatusChange = NO;
    self.rageShakeManager = [RageShakeManager sharedManager];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do not show toolbar
    [self setRoomInputToolbarViewClass:nil];
    
    // set the default extra
    [self setRoomActivitiesViewClass:nil];
    
    // Custom the attachmnet viewer
    [self setAttachmentsViewerClass:AttachmentsViewController.class];
    
    // Register first customized cell view classes used to render bubbles
    [self.bubblesTableView registerClass:FilesSearchTableViewCell.class forCellReuseIdentifier:FilesSearchTableViewCell.defaultReuseIdentifier];
    
    self.bubblesTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    // Hide line separators of empty cells
    self.bubblesTableView.tableFooterView = [[UIView alloc] init];
    
    [self setNavBarButtons];
    
    // Observe user interface theme change.
    kThemeServiceDidChangeThemeNotificationObserver = [[NSNotificationCenter defaultCenter] addObserverForName:kThemeServiceDidChangeThemeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notif) {
        
        [self userInterfaceThemeDidChange];
        
    }];
    [self userInterfaceThemeDidChange];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    // Update the inputToolBar height (This will trigger a layout refresh)
    [UIView setAnimationsEnabled:NO];
    [self roomInputToolbarView:self.inputToolbarView heightDidChanged:0 completion:nil];
    [UIView setAnimationsEnabled:YES];
}

- (void)userInterfaceThemeDidChange
{
    [ThemeService.shared.theme applyStyleOnNavigationBar:self.navigationController.navigationBar];

    self.activityIndicator.backgroundColor = ThemeService.shared.theme.overlayBackgroundColor;
    
    // Check the table view style to select its bg color.
    self.bubblesTableView.backgroundColor = ((self.bubblesTableView.style == UITableViewStylePlain) ? ThemeService.shared.theme.backgroundColor : ThemeService.shared.theme.headerBackgroundColor);
    self.view.backgroundColor = self.bubblesTableView.backgroundColor;
    self.bubblesTableView.separatorColor = ThemeService.shared.theme.lineBreakColor;
    
    if (self.bubblesTableView.dataSource)
    {
        [self.bubblesTableView reloadData];
    }

    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return ThemeService.shared.theme.statusBarStyle;
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

// This method is called when the viewcontroller is added or removed from a container view controller.
- (void)didMoveToParentViewController:(nullable UIViewController *)parent
{
    [super didMoveToParentViewController:parent];
    
    [self setNavBarButtons];
}

- (void)setNavBarButtons
{
    // Check whether the view controller is currently displayed inside a segmented view controller or not.
    UIViewController* topViewController = ((self.parentViewController) ? self.parentViewController : self);
    topViewController.navigationItem.rightBarButtonItem = nil;
    topViewController.navigationItem.leftBarButtonItem = nil;
}

#pragma mark - MXKDataSourceDelegate

- (Class<MXKCellRendering>)cellViewClassForCellData:(MXKCellData*)cellData
{
    Class cellViewClass = nil;
    
    // Sanity check
    if ([cellData conformsToProtocol:@protocol(MXKRoomBubbleCellDataStoring)])
    {
        id<MXKRoomBubbleCellDataStoring> bubbleData = (id<MXKRoomBubbleCellDataStoring>)cellData;
        
        // Select the suitable table view cell class
        if (bubbleData.attachment)
        {
            cellViewClass = FilesSearchTableViewCell.class;
        }
    }
    
    return cellViewClass;
}

- (NSString *)cellReuseIdentifierForCellData:(MXKCellData*)cellData
{
    Class class = [self cellViewClassForCellData:cellData];
    
    if ([class respondsToSelector:@selector(defaultReuseIdentifier)])
    {
        return [class defaultReuseIdentifier];
    }
    
    return nil;
}

#pragma mark - UITableView delegate

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    //only allow deletions from the user's gallery (rather than every files view in the app).
    if (!_isInGalleryContext) {
        return @[];
    }
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:NSLocalizedStringFromTable(@"room_event_action_delete", @"Vector", nil) handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        FilesSearchTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        //TODO: Remove this && false to allow this feature to work.
        if ([cell containsPatientTagData]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"error_title", @"Vector", nil) message:NSLocalizedStringFromTable(@"gallery_no_deleting_tagged_images", @"Vector", nil) preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"alert_okay", @"Vector", nil) style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            MXKCellData *cellData = [cell mxkCellData];
            if ([cellData isKindOfClass:[RoomBubbleCellData self]]) {
                RoomBubbleCellData *data = (id)cellData; //this makes Objective-C less unhappy about this sketchy cast (that we can be sure is actually safe)
                if (data) {
                    NSString *eventId = [[[data events] firstObject] eventId];

                    [self.roomDataSource.room redactEvent:eventId reason:nil success:^{
                        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    } failure:^(NSError *error) {

                        //Alert user
                        [[AppDelegate theDelegate] showErrorAsAlert:error];

                    }];
                }
            }
        }
    }];
    return @[
        action,
    ];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    cell.backgroundColor = ThemeService.shared.theme.backgroundColor;
    
    // Update the selected background view
    if (ThemeService.shared.theme.selectedBackgroundColor)
    {
        cell.selectedBackgroundView = [[UIView alloc] init];
        cell.selectedBackgroundView.backgroundColor = ThemeService.shared.theme.selectedBackgroundColor;
    }
    else
    {
        if (tableView.style == UITableViewStylePlain)
        {
            cell.selectedBackgroundView = nil;
        }
        else
        {
            cell.selectedBackgroundView.backgroundColor = nil;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.bubblesTableView)
    {
        UITableViewCell *cell = [self.bubblesTableView cellForRowAtIndexPath:indexPath];
        [self showAttachmentInCell:cell];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)changeNavigationTitle {
    [[[[AppDelegate theDelegate] masterTabBarController] navigationItem] setTitle:NSLocalizedStringFromTable(@"tab_gallery", @"Vector", @"")];
}

@end
