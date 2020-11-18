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
    @IBOutlet weak var MessageContentView: UIView!
    weak var delegate: MXKCellRenderingDelegate!
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
        guard !roomBubbleData.hasNoDisplay else { return }
        let theme = ThemeService.shared().theme
        applyTheme(TheTheme: theme)
        guard let contentView = getMessageContentView(forBubbleData: roomBubbleData) else { return }
        contentView.render(roomBubbleData)
        contentView.applyStyle(theme)
        MessageContentView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        MessageContentView.addConstraints([
            NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: MessageContentView, attribute: .bottom, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: contentView, attribute: .top, relatedBy: .equal, toItem: MessageContentView, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: contentView, attribute: .left, relatedBy: .equal, toItem: MessageContentView, attribute: .left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: contentView, attribute: .right, relatedBy: .equal, toItem: MessageContentView, attribute: .right, multiplier: 1.0, constant: 0.0)
        ])
        Sender.text = roomBubbleData.senderDisplayName
        
    }
    
    func getMessageContentView(forBubbleData data: MXKRoomBubbleCellData) -> MessageContentView! { //implicitly unwrapped because it's messy to put everything in guard/if lets
        if data.attachment != nil {
            //image
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
            
        } else {
            return 52 + height(forText: realData.attributedTextMessage, withMaxWidth: maxWidth)
        }
        return 70
    }
    
    static func height(forText text: NSAttributedString, withMaxWidth width: CGFloat) -> CGFloat{
        let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: width-50, height: 0))
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
        return theHeight + (theHeight > 18 ? 10 : 0)
    }
    
}
