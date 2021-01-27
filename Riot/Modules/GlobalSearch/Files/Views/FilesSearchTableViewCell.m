/*
 Copyright 2016 OpenMarket Ltd
 Copyright 2017 Vector Creations Ltd
 Copyright 2018 New Vector Ltd

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

#import "FilesSearchTableViewCell.h"

#import "ThemeService.h"
#import "Riot-Swift.h"

@implementation FilesSearchTableViewCell
@synthesize delegate, mxkCellData;

- (void)customizeTableViewCellRendering
{
    [super customizeTableViewCellRendering];
    
    self.title.textColor = ThemeService.shared.theme.textPrimaryColor;
    
    self.message.textColor = ThemeService.shared.theme.textSecondaryColor;
    
    self.date.tintColor = ThemeService.shared.theme.textSecondaryColor;
}

+ (CGFloat)heightForCellData:(MXKCellData *)cellData withMaximumWidth:(CGFloat)maxWidth
{
    // The height is fixed
    return 74;
}

- (void)render:(MXKCellData*)cellData
{
    [self setContainsPatientTagData:NO];
    [ObjcThemeHelpers recursiveApplyWithTheme:[ThemeService shared].theme onView:self.contentView];
    if ([self tagWarning]) {
        [self setTagWarning:NULL];
        [[self tagWarning] removeFromSuperview];
        for (UIView *view in self.contentView.subviews) {
            [view removeFromSuperview];
        }
        [self.contentView addSubview:[self originalContentView]];
        [self.contentView addConstraints:@[
            [[self originalContentView].leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
            [[self originalContentView].trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
            [[self originalContentView].topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
            [[self originalContentView].bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor]
        ]];
    }
    self.attachmentImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    if ([cellData conformsToProtocol:@protocol(MXKSearchCellDataStoring)])
    {
        [super render:cellData];
    }
    else if ([cellData isKindOfClass:[MXKRoomBubbleCellData class]])
    {
        MXKRoomBubbleCellData *bubbleData = (MXKRoomBubbleCellData*)cellData;
        mxkCellData = cellData;
        
        if (bubbleData.attachment)
        {
            self.title.text = bubbleData.attachment.originalFileName;
            
            // In case of attachment, the bubble data is composed by only one component.
            if (bubbleData.bubbleComponents.count)
            {
                MXKRoomBubbleComponent *component = bubbleData.bubbleComponents.firstObject;
                self.date.text = [bubbleData.eventFormatter dateStringFromEvent:component.event withTime:NO];
            }
            else
            {
                self.date.text = nil;
            }
            
            self.message.text = bubbleData.senderDisplayName;
            
            self.attachmentImageView.image = nil;
            self.attachmentImageView.backgroundColor = [UIColor clearColor];
            
            if (bubbleData.isAttachmentWithThumbnail)
            {
                self.attachmentImageView.backgroundColor = ThemeService.shared.theme.backgroundColor;
                [self.attachmentImageView setAttachmentThumb:bubbleData.attachment];
            }
            
            if (bubbleData.attachment.type == MXKAttachmentTypeImage) {
                [_URNDOBLabel setText:@""];
                NSDateFormatter *dateFormatter = [NSDateFormatter new];
                [dateFormatter setDateFormat:NSLocalizedStringFromTable(@"patient_dob_format", @"Vector", nil)];
                [[Services ImageTagDataService] LookupTagInfoForObjcWithURL: bubbleData.attachment.contentURL andHandler:^(NSArray *tagData) {
                    TagData *tag = [tagData lastObject];
                    PatientModel *patient = [tag.Patients firstObject];
                    bool containsChanges = [PatientTagHelpers containsTagChangesForTagData:tagData andTag:tag];
                    if ([PatientTagHelpers historyContainsPatientInTagData:tagData]) {
                        [self setContainsPatientTagData:YES];
                    }
                    if (patient) {
                        [super title].text = [PatientModel GetReorderedNameStringWithName:[patient Name]];
                        _URNDOBLabel.text = [NSString stringWithFormat:@"%@ | %@", [patient URN], [dateFormatter stringFromDate:[patient DoB]]];
                    }
                    if (containsChanges) {
                        if ([self tagWarning]) {
                            [[self tagWarning].contentView setHidden:NO];
                            [self.contentView layoutIfNeeded];
                            [self.contentView layoutSubviews];
                        } else {
                            Stackview *stackview = [Stackview new];
                            
                            
                            [self setTagWarning: (TagChangesWarning *) [[[NSBundle bundleForClass:[TagChangesWarning class]] loadNibNamed:@"TagChangesWarning" owner:[TagChangesWarning new] options:NULL] firstObject]];
                            [[self tagWarning] renderWarning];
                            [self tagWarning].contentView.translatesAutoresizingMaskIntoConstraints = NO;
                            UIView *existingView = [self.contentView.subviews firstObject];
                            [self setOriginalContentView: existingView];
                            existingView.translatesAutoresizingMaskIntoConstraints = NO;
                            NSArray *views = [[NSArray alloc] initWithObjects:[self tagWarning].contentView, existingView, nil];
                            [stackview initWithViews:views];
                            for (UIView *view in self.contentView.subviews) {
                                [view removeFromSuperview];
                            }
                            stackview.translatesAutoresizingMaskIntoConstraints = NO;
                            [self.contentView addSubview:stackview];
                            [self.contentView addConstraints:@[
                                [stackview.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
                                [stackview.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
                                [stackview.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
                                [stackview.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor]
                            ]];
                        }
                    }
                }];
            }
            
            self.iconImage.image = [self attachmentIcon:bubbleData.attachment.type];
            
            // Disable any interactions defined in the cell
            // because we want [tableView didSelectRowAtIndexPath:] to be called
            self.contentView.userInteractionEnabled = NO;
        }
        else
        {
            self.title.text = nil;
            self.date.text = nil;
            self.message.text = @"";
            
            self.attachmentImageView.image = nil;
            self.iconImage.image = nil;
        }
    }
    [ObjcThemeHelpers recursiveApplyWithTheme:[ThemeService shared].theme onView:self.contentView];
}

#pragma mark -

- (UIImage*)attachmentIcon: (MXKAttachmentType)type
{
    UIImage *image = nil;
    
    switch (type)
    {
        case MXKAttachmentTypeImage:
            image = [UIImage imageNamed:@"file_photo_icon"];
            break;
        case MXKAttachmentTypeAudio:
            image = [UIImage imageNamed:@"file_music_icon"];
            break;
        case MXKAttachmentTypeVideo:
            image = [UIImage imageNamed:@"file_video_icon"];
            break;
        case MXKAttachmentTypeFile:
            image = [UIImage imageNamed:@"file_doc_icon"];
            break;
        default:
            break;
    }
    
    return image;
}


@end
