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

class AlternateRoomCreationFlowDetails: UIViewController, UITableViewDelegate, UITableViewDataSource, SingleImagePickerPresenterDelegate, ChooseAvatarTableViewCellDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    //MARK: - Instance Variables
    @IBOutlet weak var OptionsView: UITableView!
    
    private enum RowType {
        case `default`
        case avatar(image: UIImage?)
        case textField(tag: Int, placeholder: String?, delegate: UITextFieldDelegate?)
        case textView(tag: Int, placeholder: String?, delegate: UITextViewDelegate?)
        case withSwitch(isOn: Bool, onValueChanged: ((UISwitch) -> Void)?)
        case members
    }
    
    private struct Row {
        var type: RowType
        var text: String?
        var accessoryType: UITableViewCell.AccessoryType = .none
        var action: (() -> Void)?
    }
    
    private struct Section {
        var header: String?
        var rows: [Row]
        var footer: String?
    }
    
    private enum Constants {
        static let defaultStyleCellReuseIdentifier = "default"
        static let roomNameTextFieldTag: Int = 100
        static let roomTopicTextViewTag: Int = 101
        static let roomAddressTextFieldTag: Int = 102
        static let roomNameMinimumNumberOfChars = 3
        static let roomNameMaximumNumberOfChars = 50
        static let roomAddressMaximumNumberOfChars = 50
        static let roomTopicMaximumNumberOfChars = 250
    }
    
    private var sections: [Section] = [] {
        didSet {
            OptionsView.reloadData()
        }
    }
    
    private var previousPageReference: AlternateRoomCreationFlowAddMembersController!
    
    var singleImagePickerPresenter: SingleImagePickerPresenter?
    var session: MXSession!
    
    let theme = ThemeService.shared().theme
    var creationParameters: AlternateRoomCreationParameters = AlternateRoomCreationParameters()
    
    var createButton: UIBarButtonItem!
    var mediaUploader: MXMediaLoader?
    var currentOperation: MXHTTPOperation?
    
    //MARK: - ChooseAvatarTableViewCellDelegate
    func chooseAvatarTableViewCellDidTapChooseAvatar(_ cell: ChooseAvatarTableViewCell, sourceView: UIView) {
        if creationParameters.roomAvatar != nil {
            self.singleImagePickerPresenter?.enableRemoveImage = true
        } else {
            self.singleImagePickerPresenter?.enableRemoveImage = false
        }
        
        if let presenter = self.singleImagePickerPresenter {
            presenter.present(from: self, sourceView: cell.contentView, sourceRect: cell.frame, animated: true)
        }
    }
    
    //MARK: - SingleImagePickerPresenterDelegate
    func singleImagePickerPresenter(_ presenter: SingleImagePickerPresenter, didSelectImageData imageData: Data, withUTI uti: MXKUTI?) {
        let image = UIImage(data: imageData)
        creationParameters.roomAvatar = image
        updateSections()
        OptionsView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
        presenter.dismiss(animated: true, completion: nil)
    }
    
    func singleImagePickerPresenterDidCancel(_ presenter: SingleImagePickerPresenter) {
        presenter.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Creating the room
    
    private func fixRoomAlias(alias: String?) -> String? {
        guard var alias = alias else { return nil }
        
        //  drop prefix # from room alias
        while alias.hasPrefix("#") {
            alias = String(alias.dropFirst())
        }
        
        //  TODO: Fix below somehow
        alias = alias.replacingOccurrences(of: ":matrix.org", with: "")
        if let homeserver = session.credentials.homeServer {
            alias = alias.replacingOccurrences(of: ":" + homeserver, with: "")
        }
        
        return alias
    }
    
    private func uploadAvatarIfRequired(ofRoom room: MXRoom) {
        guard let avatar = creationParameters.roomAvatar else {
            //  no avatar set, continue
            return
        }
        
        let avatarUp = MXKTools.forceImageOrientationUp(avatar)
        
        mediaUploader = MXMediaManager.prepareUploader(withMatrixSession: session, initialRange: 0, andRange: 1.0)
        mediaUploader?.uploadData(avatarUp?.jpegData(compressionQuality: 0.5),
                                  filename: nil,
                                  mimeType: "image/jpeg",
                                  success: { [weak self] (urlString) in
                                    guard let self = self else { return }
                                    guard let urlString = urlString else { return }
                                    guard let url = URL(string: urlString) else { return }
                                    self.setAvatar(ofRoom: room, withURL: url)
        }, failure: { [weak self] (error) in
            guard let self = self else { return }
            guard let error = error else { return }
            self.displayError(error.localizedDescription)
        })
    }
    
    private func setAvatar(ofRoom room: MXRoom, withURL url: URL) {
        currentOperation = room.setAvatar(url: url) { (response) in
            switch response {
            case .success:
                self.currentOperation = nil
            case .failure(let error):
                self.displayError(error.localizedDescription)
                self.currentOperation = nil
            }
        }
    }
    
    func displayError(_ ErrorMessage: String) {
        
    }
    
    var inviteCount: Int = 0 //count how many invites we need to send, then decrement by one every time an invite is sent. Finalizes room creation when this reaches 0.
    
    func displayCreatedRoom(_ room: MXRoom) {
        AppDelegate.theDelegate().showRoom(room.roomId, andEventId: nil, withMatrixSession: session)
    }
    
    func displayLoading() {
        OptionsView.isHidden = true
    }
    
    func removeLoading() {
        OptionsView.isHidden = false
    }
    
    @objc func finalizeAndCreateRoom() {
        //  compose room creation parameters in Matrix level
        let parameters = MXRoomCreationParameters()
        parameters.name = creationParameters.name
        parameters.topic = creationParameters.topic
        parameters.roomAlias = fixRoomAlias(alias: creationParameters.roomAddress)
        
        if creationParameters.publicRoom {
            parameters.preset = kMXRoomPresetPublicChat
            if creationParameters.showInDirectory {
                parameters.visibility = kMXRoomDirectoryVisibilityPublic
            } else {
                parameters.visibility = kMXRoomDirectoryVisibilityPrivate
            }
        } else {
            parameters.preset = kMXRoomPresetPrivateChat
            parameters.visibility = kMXRoomDirectoryVisibilityPrivate
        }
        
//        if roomCreationParameters.isEncrypted {
//            parameters.initialStateEvents = [MXRoomCreationParameters.initialStateEventForEncryption(withAlgorithm: kMXCryptoMegolmAlgorithm)]
//        }
        self.displayLoading()
        session.createRoom(parameters: parameters) { (response) in
            switch response {
            case .success(let room):
                self.uploadAvatarIfRequired(ofRoom: room)
                for x in self.previousPageReference.selectedItems {
                    switch x {
                    case let person as ActPeople:
                        self.inviteCount += 1
                        let inviteCompletion = {(response: MXResponse<Void>) in
                            switch response {
                            case .success:
                                self.inviteCount -= 1
                                if self.inviteCount == 0 {
                                    self.displayCreatedRoom(room)
                                }
                                
                            case .failure(let error): //if this invite doesn't work there's not a lot we can do at this point
                                self.displayError(error.localizedDescription)
                                self.removeLoading()
                            }
                        }
                        room.invite(MXRoomInvitee.userId(person.baseUser.userId), completion: inviteCompletion)
                    default:
                        break
                    }
                }
                self.currentOperation = nil
            case .failure(let error):
                self.displayError(error.localizedDescription)
                self.currentOperation = nil
            }
        }
    }
    
    //MARK:- View Lifecycle and Data management
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Room Details"
        
        OptionsView.register(cellType: ChooseAvatarTableViewCell.self)
        OptionsView.register(cellType: MXKTableViewCellWithLabelAndSwitch.self)
        OptionsView.register(cellType: MXKTableViewCellWithTextView.self)
        OptionsView.register(cellType: TextFieldTableViewCell.self)
        OptionsView.register(cellType: TextViewTableViewCell.self)
        OptionsView.register(cellType: TableViewCellWithPeopleSelector.self)
        OptionsView.register(headerFooterViewType: TextViewTableViewHeaderFooterView.self)
        OptionsView.sectionHeaderHeight = UITableView.automaticDimension
        OptionsView.estimatedSectionHeaderHeight = 50
        OptionsView.sectionFooterHeight = UITableView.automaticDimension
        OptionsView.estimatedSectionFooterHeight = 50
        
        let createText = AlternateHomeTools.getNSLocalized("create", in: "Vector")
        createButton = UIBarButtonItem(title: createText, style: .plain, target: nil, action: #selector(finalizeAndCreateRoom))
        navigationItem.rightBarButtonItem = createButton
        createButton.isEnabled = creationParameters.name?.count ?? 0 >= Constants.roomNameMinimumNumberOfChars && previousPageReference.selectedItems.count > 0
        
        updateSections()
    }
    
    private func updateSections() {
        let row_0_0 = Row(type: .avatar(image: creationParameters.roomAvatar ?? creationParameters.fallbackAvatar ?? UIImage()), text: nil, accessoryType: .none) {
            // open image picker
            if let presenter = self.singleImagePickerPresenter {
                presenter.present(from: self, sourceView: self.view, sourceRect: self.view.frame, animated: true)
            }
        }
        let section0 = Section(header: nil,
                               rows: [row_0_0],
                               footer: nil)
        
        let row_1_0 = Row(type: .textField(tag: Constants.roomNameTextFieldTag, placeholder: VectorL10n.createRoomPlaceholderName, delegate: self), text: creationParameters.name, accessoryType: .none) {
            
        }
        let section1 = Section(header: VectorL10n.createRoomSectionHeaderName,
                               rows: [row_1_0],
                               footer: nil)
        
        let row_2_0 = Row(type: .textView(tag: Constants.roomTopicTextViewTag, placeholder: VectorL10n.createRoomPlaceholderTopic, delegate: self), text: creationParameters.topic, accessoryType: .none) {
            
        }
        let section2 = Section(header: VectorL10n.createRoomSectionHeaderTopic,
                               rows: [row_2_0],
                               footer: nil)
        
        let row_3 = Row(type: .withSwitch(isOn: false, onValueChanged: {theSwitch in
            self.creationParameters.publicRoom = theSwitch.isOn
        }), text: VectorL10n.createRoomTypePublic, accessoryType: .none, action: nil)
        
        let section3 = Section(header: VectorL10n.createRoomSectionHeaderType,
                               rows: [row_3],
                               footer: VectorL10n.createRoomSectionFooterType)
        
        var tmpSections: [Section] = [
            section0,
            section1,
            section2,
            section3
        ]
        
        let membercount = previousPageReference.selectedItems.count
        
        let singleMemberString = AlternateHomeTools.getNSLocalized("room_info_list_one_member", in: "Vector")
        
        //need to run this replace because membercount is primitive, and the format string uses %@ which causes a crash
        let multipleMemberString = AlternateHomeTools.getNSLocalized("room_info_list_several_members", in: "Vector").replacingOccurrences(of: "%@", with: "%i")
        let memberstring = membercount == 1 ? singleMemberString : String(format: multipleMemberString, NSInteger(membercount))
        
        let finalSection = Section(header: memberstring, rows: [Row(type: .members)], footer: nil)
        tmpSections.append(finalSection)
        
        sections = tmpSections
    }
    
    func Setup(_ to: AlternateRoomCreationFlowAddMembersController, parameters roomParams: AlternateRoomCreationParameters) {
        previousPageReference = to
        creationParameters = roomParams
        if let session: MXSession = AppDelegate.theDelegate().mxSessions.first as? MXSession {
            singleImagePickerPresenter = SingleImagePickerPresenter(session: session)
            singleImagePickerPresenter?.setRemoveImageHandler {
                self.creationParameters.roomAvatar = nil
                self.updateSections()
                self.OptionsView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
            }
            singleImagePickerPresenter?.delegate = self
            self.session = session
        }
    }
    
    //MARK:- TableView Delegate / Datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = theme.backgroundColor
        cell.selectedBackgroundView = UIView()
        cell.selectedBackgroundView?.backgroundColor = theme.selectedBackgroundColor
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view: TextViewTableViewHeaderFooterView? = tableView.dequeueReusableHeaderFooterView()
        guard let header = sections[section].header else {
            view?.update(theme: theme)
            return view
        }

        view?.textView.text = header
        view?.textView.font = .systemFont(ofSize: 13)
        view?.textViewInsets = UIEdgeInsets(top: 16, left: 16, bottom: 8, right: 16)
        view?.update(theme: theme)

        return view
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view: TextViewTableViewHeaderFooterView? = tableView.dequeueReusableHeaderFooterView()
        guard let footer = sections[section].footer else {
            view?.update(theme: theme)
            return view
        }
        
        view?.textView.text = footer
        view?.textView.font = .systemFont(ofSize: 13)
        view?.update(theme: theme)

        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = sections[indexPath.section].rows[indexPath.row]
        
        switch row.type {
        case .avatar:
            return 100
        case .textView:
            return 150
        case .members:
            return 135
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if sections[section].header == nil {
            return 18
        }
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if sections[section].footer == nil {
            return 18
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].header
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        sections[section].footer
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let row = sections[indexPath.section].rows[indexPath.row]
        row.action?()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = sections[indexPath.section].rows[indexPath.row]
        
        switch row.type {
        case .default:
            var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: Constants.defaultStyleCellReuseIdentifier)
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: Constants.defaultStyleCellReuseIdentifier)
            }
            cell.textLabel?.font = .systemFont(ofSize: 17)
            cell.detailTextLabel?.font = .systemFont(ofSize: 16)
            cell.textLabel?.text = row.text
            if row.accessoryType == .checkmark {
                cell.accessoryView = UIImageView(image: Asset.Images.checkmark.image)
            } else {
                cell.accessoryView = nil
                cell.accessoryType = row.accessoryType
            }
            cell.textLabel?.textColor = theme.textPrimaryColor
            cell.detailTextLabel?.textColor = theme.textSecondaryColor
            cell.backgroundColor = theme.backgroundColor
            cell.contentView.backgroundColor = .clear
            cell.tintColor = theme.tintColor
            return cell
        case .avatar(let image):
            let cell: ChooseAvatarTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(withViewModel: ChooseAvatarTableViewCellVM(avatarImage: image))
            cell.delegate = self
            cell.update(theme: theme)
            
            return cell
        case .textField(let tag, let placeholder, let delegate):
            let cell: TextFieldTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.textField.font = .systemFont(ofSize: 17)
            cell.textField.insets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
            cell.textField.autocapitalizationType = .words
            cell.textField.tag = tag
            cell.textField.placeholder = placeholder
            cell.textField.text = row.text
            cell.textField.delegate = delegate
            
            switch tag {
            case Constants.roomAddressTextFieldTag:
                cell.textField.autocapitalizationType = .none
            default: break
            }
            
            cell.update(theme: theme)
            
            return cell
        case .textView(let tag, let placeholder, let delegate):
            let cell: TextViewTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.textView.tag = tag
            cell.textView.textContainer.lineFragmentPadding = 0
            cell.textView.contentInset = .zero
            cell.textView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
            cell.textView.placeholder = placeholder
            cell.textView.font = .systemFont(ofSize: 17)
            cell.textView.text = row.text
            cell.textView.isEditable = true
            cell.textView.isScrollEnabled = false
            cell.textView.delegate = delegate
            cell.textView.backgroundColor = .clear
            cell.update(theme: theme)
            
            return cell
        case .withSwitch(let isOn, let onValueChanged):
            let cell: MXKTableViewCellWithLabelAndSwitch = tableView.dequeueReusableCell(for: indexPath)
            cell.mxkLabel.font = .systemFont(ofSize: 17)
            cell.mxkLabel.text = row.text
            cell.mxkSwitch.isOn = isOn
            cell.mxkSwitch.removeTarget(nil, action: nil, for: .valueChanged)
            cell.mxkSwitch.vc_addAction(for: .valueChanged) {
                onValueChanged?(cell.mxkSwitch)
            }
            cell.mxkLabelLeadingConstraint.constant = cell.vc_separatorInset.left
            cell.mxkSwitchTrailingConstraint.constant = 15
            cell.update(theme: theme)
            
            return cell
        case .members:
            let cell: TableViewCellWithPeopleSelector = tableView.dequeueReusableCell(for: indexPath)
            cell.EmbeddedCollectionView.dataSource = previousPageReference
            cell.EmbeddedCollectionView.delegate = previousPageReference as? UICollectionViewDelegate
            cell.EmbeddedCollectionView.register(UINib(nibName: String(describing: RoomCreationCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: RoomCreationCollectionViewCell.self))
            previousPageReference.selectionChangedComplete = {
                self.createButton.isEnabled = self.creationParameters.name?.count ?? 0 >= Constants.roomNameMinimumNumberOfChars && self.previousPageReference.selectedItems.count > 0
                cell.EmbeddedCollectionView.reloadData()
            }
            return cell
        }
    }
    
    //MARK:- Text Field Delegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case Constants.roomNameTextFieldTag:
            creationParameters.name = textField.text
            if creationParameters.roomAvatar == nil {
                //  if no image selected by the user, set initials as image
                let avatar = AvatarGenerator.generateAvatar(forMatrixItem: nil,
                                                            withDisplayName: textField.text)
                creationParameters.fallbackAvatar = avatar
            }
        case Constants.roomAddressTextFieldTag:
            creationParameters.roomAddress = textField.text
        default:
            break
        }
        
        updateSections()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text: NSString = (textField.text ?? "") as NSString
        let resultString = text.replacingCharacters(in: range, with: string)
        let resultCount = resultString.count
        
        switch textField.tag {
        case Constants.roomNameTextFieldTag:
            createButton.isEnabled = resultCount >= Constants.roomNameMinimumNumberOfChars && previousPageReference.selectedItems.count > 0
            let result = resultCount <= Constants.roomNameMaximumNumberOfChars
            if result {
                creationParameters.name = resultString
            }
            return result
        case Constants.roomAddressTextFieldTag:
            let result = resultCount <= Constants.roomAddressMaximumNumberOfChars
            if result {
                creationParameters.roomAddress = resultString
            }
            return result
        default:
            return true
        }
    }
    
    //MARK:- Text View Delegate
    func textViewDidEndEditing(_ textView: UITextView) {
        switch textView.tag {
        case Constants.roomTopicTextViewTag:
            creationParameters.topic = textView.text
        default:
            break
        }
    }
}
