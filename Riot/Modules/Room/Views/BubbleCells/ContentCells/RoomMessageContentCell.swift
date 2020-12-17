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
    @IBOutlet weak var AvatarImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var SenderNameHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var Sender: UILabel!
    @IBOutlet weak var SenderAvatar: MXKImageView!
    @IBOutlet weak var MessageContentView: UITableView!
    @IBOutlet weak var PaginationSpace: UIView!
    
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
        MessageContentView.register(UINib(nibName: "PatientViewCell", bundle: nil), forCellReuseIdentifier: "PatientViewCell")
    }
    
    //using a getter here because when we introduce accessibility, we may want to allow the avatar image to resize as well as the text.
    static var avatarImageWidth: CGFloat {
        return 33
    }
    
    static var nonUsableWidth: CGFloat {
        return avatarImageWidth + 20
    }
    
    static var paginationFontSize: CGFloat {
        return 20
    }
    static var paginationPaddingConstant: CGFloat {
        return 10
    }
    
    static func createPaginator(_ cellData: MXKRoomBubbleCellData) -> UIView {
        let paginationlabel = UILabel()
        let dateString = EventFormatter(matrixSession: cellData.mxSession).dateString(fromTimestamp: cellData.events.first?.originServerTs ?? 0, withTime: false)
        paginationlabel.text = dateString?.uppercased()
        paginationlabel.translatesAutoresizingMaskIntoConstraints = false
        paginationlabel.textAlignment = .center
        paginationlabel.font = UIFont.boldSystemFont(ofSize: paginationFontSize)
        paginationlabel.textColor = ThemeService.shared().theme.tintColor
        paginationlabel.sizeToFit()
        let paginatorStackview = Stackview()
        paginatorStackview.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        let separatorView = UIView()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.addConstraint(separatorView.heightAnchor.constraint(equalToConstant: paginationPaddingConstant * 2))
        
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = ThemeService.shared().theme.tintColor
        separator.addConstraint(separator.heightAnchor.constraint(equalToConstant: 1))
        separatorView.addSubview(separator)
        let widthAnchor = separator.widthAnchor.constraint(equalToConstant: 0)
        separatorView.addConstraints(
            [
                separator.centerXAnchor.constraint(equalTo: separatorView.centerXAnchor),
                separator.centerYAnchor.constraint(equalTo: separatorView.centerYAnchor),
                widthAnchor
            ])
        
        let topPadding = UIView()
        topPadding.translatesAutoresizingMaskIntoConstraints = false
        topPadding.addConstraint(topPadding.heightAnchor.constraint(equalToConstant: paginationPaddingConstant))
        
        let stackItems: [UIView] = [topPadding, paginationlabel, separatorView]
        paginatorStackview.initWithViews(stackItems)
        paginatorStackview.layoutIfNeeded()
        
        
        let labelWidth = paginationlabel.frame.width
        //animation looks a little silly because every time a cell is tapped the whole tableview reloads, forcing this animation to replay. When that's fixed this should maybe be re-enabled
//        UIView.animate(withDuration: 0.05) {
//            paginatorStackview.layoutIfNeeded()
//        } completion: { (complete) in
//            widthAnchor.constant = labelWidth * 3
//            UIView.animate(withDuration: 0.6) {
//                paginatorStackview.layoutIfNeeded()
//            }
//        }
        
        widthAnchor.constant = labelWidth * 3
        paginatorStackview.layoutIfNeeded()

        
        return paginatorStackview
    }
    
    static func getPaginatorHeight() -> CGFloat {
        let paginationlabel = UILabel()
        paginationlabel.frame = CGRect.zero
        let dateString = "12 dec"
        paginationlabel.text = dateString.uppercased()
        paginationlabel.translatesAutoresizingMaskIntoConstraints = false
        paginationlabel.textAlignment = .center
        paginationlabel.font = UIFont.boldSystemFont(ofSize: paginationFontSize)
        paginationlabel.sizeToFit()
        
        let labelHeight = paginationlabel.frame.height
        return paginationPaddingConstant + labelHeight + paginationPaddingConstant * 2 //top padding + label + bottom padding
    }
    
    static func getMXRoomBubbleData(_ cellData: MXKCellData!) -> MXKRoomBubbleCellData? {
        var roomBubbleData: MXKRoomBubbleCellData?
        if let bubbleData = cellData as? MXKRoomBubbleCellDataWithAppendingMode {
            roomBubbleData = bubbleData
        } else if let bubbleData = cellData as? MXKRoomBubbleCellDataWithIncomingAppendingMode {
            roomBubbleData = bubbleData
        } else if let roomBubbleDataTemp = cellData as? MXKRoomBubbleCellData {
            roomBubbleData = roomBubbleDataTemp
        }
        return roomBubbleData
    }
    
    override func render(_ cellData: MXKCellData!) {
        
        guard let roomBubbleData = type(of:self).getMXRoomBubbleData(cellData) else { return }
        
        self.cellData = roomBubbleData
        guard !(roomBubbleData.hasNoDisplay && roomBubbleData.attributedTextMessage == nil) else {
            return
        }
        
        applyTheme(TheTheme: theme)
        
        for subview in PaginationSpace.subviews {
            subview.removeFromSuperview()
        }
        
        if roomBubbleData.isPaginationFirstBubble {
            ThemeService.shared().theme.recursiveApply(on: PaginationSpace)
            let paginationlabel = type(of: self).createPaginator(roomBubbleData)
            PaginationSpace.addSubview(paginationlabel)
            PaginationSpace.addConstraints(
                [
                    paginationlabel.leadingAnchor.constraint(equalTo: PaginationSpace.leadingAnchor),
                    paginationlabel.trailingAnchor.constraint(equalTo: PaginationSpace.trailingAnchor),
                    paginationlabel.topAnchor.constraint(equalTo: PaginationSpace.topAnchor),
                    paginationlabel.bottomAnchor.constraint(equalTo: PaginationSpace.bottomAnchor)
                ]
            )
        }
        
        self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(onLongPressEvent)))
        
        Sender.text = roomBubbleData.senderDisplayName
        Sender.textColor = ThemeService.shared().theme.userNameColors.first
        SenderAvatar.enableInMemoryCache = true
        SenderAvatar.setImageURI(roomBubbleData.senderAvatarUrl,
                                 withType: nil,
                                 andImageOrientation: .up,
                                 toFitViewSize: SenderAvatar.frame.size,
                                 with: MXThumbnailingMethodCrop,
                                 previewImage: roomBubbleData.senderAvatarPlaceholder != nil ? roomBubbleData.senderAvatarPlaceholder : AvatarGenerator.generateAvatar(forMatrixItem: roomBubbleData.roomId, withDisplayName: roomBubbleData.senderDisplayName),
                                 mediaManager: roomBubbleData.mxSession.mediaManager)
        AvatarImageHeightConstraint.constant = RoomMessageContentCell.avatarImageWidth
        SenderAvatar.layer.cornerRadius = RoomMessageContentCell.avatarImageWidth / 2
        SenderAvatar.clipsToBounds = true
        if roomBubbleData.shouldHideSenderInformation {
            AvatarImageHeightConstraint.constant = 0
            SenderNameHeightConstraint.constant = 0
            contentView.layoutIfNeeded()
            
        } else {
            AvatarImageHeightConstraint.constant = RoomMessageContentCell.avatarImageWidth
            SenderNameHeightConstraint.constant = 21
            contentView.layoutIfNeeded()
        }
        
        let avatarViewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(avatarViewTapped))
        SenderAvatar.addGestureRecognizer(avatarViewTapGestureRecognizer)
        
        MessageContentView.rowHeight = UITableView.automaticDimension
        MessageContentView.estimatedRowHeight = 44.0
        MessageContentView.reloadData()
        MessageContentView.backgroundColor = ThemeService.shared().theme.backgroundColor
    }
    
    @objc func avatarViewTapped() {
        guard let datasource = delegate as? MXKRoomDataSource else { return }
        datasource.cell(self, didRecognizeAction: kMXKRoomBubbleCellTapOnAvatarView, userInfo: [kMXKRoomBubbleCellUserIdKey: bubbleData.senderId])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.cellData != nil else {
            return 0
            
        }
        return max(componentCount, 1)//(cellData.attachment != nil ? 2 : 1))
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
        } else if indexPath.row == 0 {
            if let renderer = getMessageContentViewIdentifier(forBubbleData: cellData) {
                let cell = tableView.dequeueReusableCell(withIdentifier: renderer, for: indexPath)
                if let concrete = cell as? MessageContentView {
                    concrete.render(celldata: cellData, width: tableView.frame.width)
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
            //image or video
            if data.isAttachmentWithThumbnail {
                return MessageImageView.reuseIdentifier()
            }
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
        guard let realData = getMXRoomBubbleData(cellData) else { return 0 }
        guard !(realData.hasNoDisplay && realData.attributedTextMessage == nil) else
        {
            return 0
        }
        
        var baseHeight: CGFloat = (realData.shouldHideSenderInformation ? 0 : avatarImageWidth)
        
        if realData.isPaginationFirstBubble {
            baseHeight += getPaginatorHeight()
        }
        
        if realData.bubbleComponents.count > 1 || (realData.bubbleComponents.count == 1 && !realData.hasAttributedTextMessage) {
            var returnHeight: CGFloat = 0.0
            for item in realData.bubbleComponents where item.attributedTextMessage != nil {
                returnHeight += height(forText: item.attributedTextMessage, withMaxWidth: maxWidth - nonUsableWidth)
            }
            return returnHeight + baseHeight
        }
        var returnHeight: CGFloat = 0
        if realData.attachment != nil {
            returnHeight = MessageImageView.calculateHeight(forWidth: maxWidth - nonUsableWidth, andCellData: realData) + baseHeight
        } else {
            returnHeight = baseHeight + height(forText: realData.attributedTextMessage, withMaxWidth: maxWidth - nonUsableWidth)
        }
        return returnHeight
    }
    
    static func height(forText text: NSAttributedString, withMaxWidth width: CGFloat) -> CGFloat {
        let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: 0))
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.removeConstraints(lbl.constraints)
        lbl.adjustsFontSizeToFitWidth = false
        lbl.attributedText = text
        lbl.numberOfLines = 0
        
        lbl.sizeToFit()
        lbl.layoutIfNeeded()
        let frame = lbl.frame
        let theHeight = frame.height
        return theHeight * 1.05
    }
}
