// 
// Copyright 2020 New Vector Ltd
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation

class RoomMessageContentCell: UITableViewCell, MXKCellRendering {
    @IBOutlet weak var Sender: UILabel!
    @IBOutlet weak var SenderAvatar: MXKImageView!
    @IBOutlet weak var MessageContentView: UIStackView!
    weak var delegate: MXKCellRenderingDelegate!
    @objc var bubbleData: MXKRoomBubbleCellData!
    static func nib() -> UINib! {
        UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        MessageContentView.subviews.forEach { (x) in
            x.removeFromSuperview()
        }
    }
    
    func render(_ cellData: MXKCellData!) {
        guard let roomBubbleData = cellData as? MXKRoomBubbleCellData else { return }
        bubbleData = roomBubbleData
        guard !roomBubbleData.hasNoDisplay else { return }
        let theme = ThemeService.shared().theme
        applyTheme(TheTheme: theme)
        guard let contentView = getMessageContentView(forBubbleData: roomBubbleData) else { return }
        contentView.delegate = self
        contentView.render(roomBubbleData)
        contentView.applyStyle(theme)
        MessageContentView.backgroundColor = .none
        MessageContentView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        MessageContentView.addConstraints([
            NSLayoutConstraint(item: contentView, attribute: .left, relatedBy: .equal, toItem: MessageContentView, attribute: .left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: contentView, attribute: .right, relatedBy: .lessThanOrEqual, toItem: MessageContentView, attribute: .right, multiplier: 1.0, constant: 0.0)
        ])
        Sender.text = roomBubbleData.senderDisplayName
        SenderAvatar.enableInMemoryCache = true
        SenderAvatar.setImageURI(roomBubbleData.senderAvatarUrl,
                                 withType: nil,
                                 andImageOrientation: .up,
                                 toFitViewSize: SenderAvatar.frame.size,
                                 with: MXThumbnailingMethodCrop,
                                 previewImage: roomBubbleData.senderAvatarPlaceholder != nil ? roomBubbleData.senderAvatarPlaceholder : AvatarGenerator.generateAvatar(forMatrixItem: roomBubbleData.roomId, withDisplayName: roomBubbleData.senderDisplayName),
                                 mediaManager: roomBubbleData.mxSession.mediaManager)
        SenderAvatar.layer.cornerRadius = SenderAvatar.frame.height / 2
        SenderAvatar.clipsToBounds = true
        if roomBubbleData.shouldHideSenderInformation {
            SenderAvatar.addConstraint(SenderAvatar.heightAnchor.constraint(equalToConstant: 0))
            Sender.addConstraint(Sender.heightAnchor.constraint(equalToConstant: 0))
        }
    }
    
    func getMessageContentView(forBubbleData data: MXKRoomBubbleCellData) -> MessageContentView! { //implicitly unwrapped because it's messy to put everything in guard/if lets
        if data.attachment != nil {
            //image
            let image = MessageImageView()
            image.backgroundColor = .cyan
            image.addConstraints([
                NSLayoutConstraint(item: image, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: data.contentSize.width),
                NSLayoutConstraint(item: image, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: data.contentSize.height)
            ])
            return image
        } else {
            return MessageTextView()
        }
        return nil
    }
    
    func applyTheme(TheTheme theme: Theme) {
        Sender.textColor = theme.textPrimaryColor
    }
    
    static func height(for cellData: MXKCellData!, withMaximumWidth maxWidth: CGFloat) -> CGFloat {
        guard let realData = cellData as? MXKRoomBubbleCellData else { return 0 }
        guard !realData.hasNoDisplay else { return 0 }
        if realData.attachment != nil {
            return realData.contentSize.height + (realData.shouldHideSenderInformation ? 0 : 32)
        } else {
            return (realData.shouldHideSenderInformation ? 0 : 32) + height(forText: realData.attributedTextMessage, withMaxWidth: maxWidth)
        }
        return 70
    }
    
    static func height(forText text: NSAttributedString, withMaxWidth width: CGFloat) -> CGFloat {
        let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: width-60, height: 0))
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.removeConstraints(lbl.constraints)
        lbl.adjustsFontSizeToFitWidth = false
        lbl.addConstraint(NSLayoutConstraint(item: lbl, attribute: .width, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 10/*(width - 100)*/))
        lbl.attributedText = text
        lbl.numberOfLines = 0
        
        lbl.sizeToFit()
        lbl.layoutIfNeeded()
        let frame = lbl.frame
        let theHeight = frame.height
        return theHeight * 1.25
    }
}
