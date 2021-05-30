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

@interface RoomFilesViewController () <CameraPresenterDelegate>
{
    /**
     Observe kThemeServiceDidChangeThemeNotification to handle user interface theme change.
     */
    id kThemeServiceDidChangeThemeNotificationObserver;
}

@property CameraPresenter *cameraPresenter;

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
    
    if ([self isInGalleryContext] && !([self galleryTakePhotoButton])) {
        if (@available(iOS 13.0, *)) {
            UIImage *image = [UIImage systemImageNamed:@"camera.fill"];
            _galleryTakePhotoButton = [UIButton systemButtonWithImage:image target:self action:@selector(takePhoto)];
            _galleryTakePhotoButton.translatesAutoresizingMaskIntoConstraints = NO;
            _galleryTakePhotoButton.tintColor = [ThemeService shared].theme.tintColor;
            _galleryTakePhotoButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
            _galleryTakePhotoButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
            [_galleryTakePhotoButton addConstraints:@[
                [[_galleryTakePhotoButton widthAnchor] constraintEqualToConstant:40],
                [[_galleryTakePhotoButton heightAnchor] constraintEqualToConstant:30],
            ]];
            
            [[self view] addSubview:_galleryTakePhotoButton];
            [[self view] addConstraints:@[
                [[self view].centerXAnchor constraintEqualToAnchor:[_galleryTakePhotoButton centerXAnchor]],
                [[self view].bottomAnchor constraintEqualToAnchor:[_galleryTakePhotoButton bottomAnchor] constant:10]
            ]];
            
        } else {
            // Fallback on earlier versions
        }
        
        
    }
}

- (void)takePhoto {
    CameraPresenter *cameraPresenter = [CameraPresenter new];
    cameraPresenter.delegate = self;
    [cameraPresenter presentCameraFrom:self with:@[MXKUTI.image, MXKUTI.movie] animated:YES];
    self.cameraPresenter = cameraPresenter;
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
    
    if (self.showCancelBarButtonItem)
    {
        topViewController.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancel:)];
    }
    else
    {
        topViewController.navigationItem.leftBarButtonItem = nil;
    }
}

- (void)onCancel:(id)sender
{
    [self withdrawViewControllerAnimated:YES completion:nil];
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

#pragma mark - CameraPresenterDelegate

- (void)cameraPresenterDidCancel:(CameraPresenter *)cameraPresenter
{
    [cameraPresenter dismissWithAnimated:YES completion:nil];
    self.cameraPresenter = nil;
}

- (void)cameraPresenter:(CameraPresenter *)cameraPresenter didSelectImageData:(NSData *)imageData withUTI:(MXKUTI *)uti
{
    if (BuildSettings.sendMessageRequirePatientTagging){
        
        [cameraPresenter dismissWithAnimated:YES completion:^{
            PatientTaggingViewController *PatientTaggingController = [PatientTaggingViewController new];
            [PatientTaggingController setImageTo: imageData WithHandler:^(TagData *tagData) {
                if (tagData.Patients.count > 0){
                    //A patient was tagged
                    //TODO: Replace this debug message with the actual actions necessary to tag the patient and upload to CPF.
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Tagged Photo Uploaded"
                                                   message:@"The tagged photo of the patient would now be uploaded, with relevant tag data being stored by the CPF. This feature is pending on updates to the backend."
                                                   preferredStyle:UIAlertControllerStyleAlert];

                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];

                    [alert addAction:defaultAction];
                    [self presentViewController:alert animated:YES completion:nil];
                    [[self roomDataSource] sendImage:imageData mimeType:uti.mimeType success:^(NSString *success) {
                        NSLog(@"Sent");
                    } failure:^(NSError *err) {
                        NSLog(@"err");
                    }];
                    
                } else {
                    [[self roomDataSource] sendImage:imageData mimeType:uti.mimeType success:^(NSString *success) {
                        NSLog(@"Sent");
                    } failure:^(NSError *err) {
                        NSLog(@"err");
                    }];
                }
            }];
            [self showViewController:PatientTaggingController sender:self];
        }];
        self.cameraPresenter = nil;
        
    }else{
        [cameraPresenter dismissWithAnimated:YES completion:nil];
        self.cameraPresenter = nil;
        
        [[self roomDataSource] sendImage:imageData mimeType:uti.mimeType success:^(NSString *success) {
            NSLog(@"Sent");
        } failure:^(NSError *err) {
            NSLog(@"err");
        }];
    }
}

- (void)cameraPresenter:(CameraPresenter *)cameraPresenter didSelectVideoAt:(NSURL *)url
{
    [cameraPresenter dismissWithAnimated:YES completion:nil];
    self.cameraPresenter = nil;
    [[self roomDataSource] sendVideo:url withThumbnail:nil success:^(NSString *eventId) {
        
    } failure:^(NSError *error) {
        
    }];
}

@end
