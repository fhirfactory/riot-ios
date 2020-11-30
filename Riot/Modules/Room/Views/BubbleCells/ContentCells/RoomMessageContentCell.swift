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

class RoomMessageContentCell: MXKRoomBubbleTableViewCell, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var Sender: UILabel!
    @IBOutlet weak var SenderAvatar: MXKImageView!
    @IBOutlet weak var MessageContentView: UITableView!
    private var componentCount: Int {
        if cellData == nil {
            return 0
        }
        return cellData.bubbleComponents.count == 0 ? (cellData.hasNoDisplay ? 0 : 1) : cellData.bubbleComponents.count
    }
    private var theme: Theme {
        ThemeService.shared().theme
    }
    
    var cellData: MXKRoomBubbleCellData!
    @objc override var bubbleData: MXKRoomBubbleCellData! {
        return cellData
    }
    @objc override var mxkCellData: MXKCellData! {
        return bubbleData
    }
    override static func nib() -> UINib! {
        UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        registerReuseIdentifiers()
    }
    
    override func prepareForReuse() {
        MessageContentView.subviews.forEach { (x) in
            x.removeFromSuperview()
        }
    }
    
    override func updateConstraints() {
        super.updateConstraints()
    }
    
    func registerReuseIdentifiers() {
        MessageContentView.register(MessageTextView.nib(), forCellReuseIdentifier: MessageTextView.reuseIdentifier())
        MessageContentView.register(MessageImageView.nib(), forCellReuseIdentifier: MessageImageView.reuseIdentifier())
    }
    
    override func render(_ cellData: MXKCellData!) {
        guard let roomBubbleData = cellData as? MXKRoomBubbleCellData else { return }
        self.cellData = roomBubbleData
        guard !roomBubbleData.hasNoDisplay else { return }
        applyTheme(TheTheme: theme)
        
//        var successfullyCreatedBubbles = false
//        if roomBubbleData.bubbleComponents.count > 1 {
//            for component in roomBubbleData.bubbleComponents {
//                guard let contentView = getMessageContentView(forBubbleData: roomBubbleData) else { successfullyCreatedBubbles = false; break }
//                guard let renderer = contentView as? RendersBubbleComponent else { successfullyCreatedBubbles = false; break }
//                contentView.delegate = self
//                renderer.render(component: component)
//                contentView.applyStyle(theme)
//                MessageContentView.backgroundColor = .none
//                MessageContentView.addSubview(contentView)
//                contentView.translatesAutoresizingMaskIntoConstraints = false
//                MessageContentView.addConstraints([
//                    NSLayoutConstraint(item: contentView, attribute: .left, relatedBy: .equal, toItem: MessageContentView, attribute: .left, multiplier: 1.0, constant: 0.0),
//                    NSLayoutConstraint(item: contentView, attribute: .right, relatedBy: .lessThanOrEqual, toItem: MessageContentView, attribute: .right, multiplier: 1.0, constant: 0.0)
//                ])
//            }
//            successfullyCreatedBubbles = true
//        }
//
//        //for component in bubbleData.bubbleComponents {
//        if !successfullyCreatedBubbles {
//            guard let contentView = getMessageContentView(forBubbleData: roomBubbleData) else { return }
//            contentView.delegate = self
//            contentView.render(roomBubbleData)
//            contentView.applyStyle(theme)
//            MessageContentView.backgroundColor = .none
//            MessageContentView.addSubview(contentView)
//            contentView.translatesAutoresizingMaskIntoConstraints = false
//            MessageContentView.addConstraints([
//                NSLayoutConstraint(item: contentView, attribute: .left, relatedBy: .equal, toItem: MessageContentView, attribute: .left, multiplier: 1.0, constant: 0.0),
//                NSLayoutConstraint(item: contentView, attribute: .right, relatedBy: .lessThanOrEqual, toItem: MessageContentView, attribute: .right, multiplier: 1.0, constant: 0.0)
//            ])
//        }
        //}
        
        self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(onLongPressEvent)))
        
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
        
        MessageContentView.rowHeight = UITableView.automaticDimension
        MessageContentView.estimatedRowHeight = 44.0
        MessageContentView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return componentCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if componentCount > 1 {
            let component = cellData.bubbleComponents[indexPath.row]
            if let componentIdentifier = getComponentContentIdentifier(forBubbleComponent: component) {
                let cell = tableView.dequeueReusableCell(withIdentifier: componentIdentifier, for: indexPath)
                if let concrete = cell as? RendersBubbleComponent {
                    concrete.render(component: component)
                    if let concreteContentView = cell as? MessageContentView {
                        concreteContentView.delegate = self
                        concreteContentView.hasLoadedView()
                        concreteContentView.applyStyle(theme)
                    }
                    return cell
                }
            }
        } else {
            if let renderer = getMessageContentViewIdentifier(forBubbleData: cellData) {
                let cell = tableView.dequeueReusableCell(withIdentifier: renderer, for: indexPath)
                if let concrete = cell as? MessageContentView {
                    concrete.render(cellData)
                    concrete.delegate = self
                    concrete.hasLoadedView()
                    concrete.applyStyle(theme)
                    return cell
                }
            }
        }
        return UITableViewCell()
    }
    
    func getComponentContentIdentifier(forBubbleComponent data: MXKRoomBubbleComponent) -> String? {
        if data.attributedTextMessage != nil {
            return MessageTextView.reuseIdentifier()
        }
        return nil
    }
    
    func getMessageContentViewIdentifier(forBubbleData data: MXKRoomBubbleCellData) -> String? { //implicitly unwrapped because it's messy to put everything in guard/if lets
        if data.attachment != nil {
            //image
            return MessageImageView.reuseIdentifier()
        } else {
            return MessageTextView.reuseIdentifier()
        }
        return nil
    }
    
    func applyTheme(TheTheme theme: Theme) {
        Sender.textColor = theme.textPrimaryColor
    }
    
    @IBAction private func onLongPressEvent() {
        delegate.cell(self, didRecognizeAction: kMXKRoomBubbleCellLongPressOnEvent, userInfo: nil)
    }
    
    override static func height(for cellData: MXKCellData!, withMaximumWidth maxWidth: CGFloat) -> CGFloat {
        guard let realData = cellData as? MXKRoomBubbleCellData else { return 0 }
        guard !realData.hasNoDisplay else { return 0 }
        if realData.bubbleComponents.count > 1 {
            var returnHeight: CGFloat = 0.0
            for item in realData.bubbleComponents {
                if item.attributedTextMessage != nil {
                    returnHeight += height(forText: item.attributedTextMessage, withMaxWidth: maxWidth)
                }
            }
            return returnHeight + (realData.shouldHideSenderInformation ? 0 : 32)
        }
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
