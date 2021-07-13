//
//  PeopleProfileTableViewCell.swift
//  Riot
//
//  Created by Naurin Afrin on 5/8/20.
//  Copyright © 2020 matrix.org. All rights reserved.
//

import UIKit

class PeopleProfileTableViewCell: UITableViewCell {
    
    var person: ActPeopleModel!
    @IBOutlet weak var avatar: MXKImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var organisation: UILabel!
    @IBOutlet weak var businessUnit: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ThemeService.shared().theme.recursiveApply(on: self.contentView)
    }
    @IBAction private func StartChatOption(_ sender: Any) {
        AppDelegate.theDelegate().startDirectChat(withUserId: person.matrixID, completion: {
            
        })
    }
    @IBAction private func StartAudioCallOption(_ sender: Any) {
        placeCallWithUser(withVideo: false)
    }
    @IBAction private func StartVideoCallOption(_ sender: Any) {
        placeCallWithUser(withVideo: true)
    }
    
    func placeCallWithUser(withVideo video: Bool) {
        
        // TODO:- This code block needs to be replaced with appropriate code once the backend is available and can provide role information to the app
        
        let userID = person.matrixID
        if let theSession = (AppDelegate.theDelegate().mxSessions.first as? MXSession) {
            if let room: MXRoom = theSession.directJoinedRoom(withUserId: userID) {
                room.placeCall(withVideo: video, completion: {(callResult) in
                    if callResult.isFailure {
                        
                    }
                })
            } else {
                let roomCreationParameters = MXRoomCreationParameters(forDirectRoomWithUser: userID)
                theSession.createRoom(parameters: roomCreationParameters, completion: {(creationResult) in
                    if creationResult.isSuccess {
                        DispatchQueue.main.async {
                            if let room = creationResult.value {
                                room.placeCall(withVideo: video, completion: {(result) in
                                    
                                })
                            }
                        }
                    } else {
                        NotificationCenter.default.post(name: NSNotification.Name.mxkError, object: creationResult.error, userInfo: theSession.myUser.userId != nil ? [kMXKErrorUserIdKey: theSession.myUser.userId!] : nil)
                    }
                })
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setPerson(person: ActPeopleModel) {
        self.person = person
        name.text = person.displayName
        jobTitle.text = person.jobTitle
        organisation.text = person.organisation
        businessUnit.text = person.businessUnit
        avatar.setImageURI(person.avatarURL, withType: nil, andImageOrientation: UIImage.Orientation.up, previewImage: AvatarGenerator.generateAvatar(forText: person.displayName), mediaManager: (AppDelegate.theDelegate().mxSessions.first as? MXSession)?.mediaManager)
        avatar.layer.cornerRadius = avatar.frame.width / 2
        avatar.layer.masksToBounds = true
    }
    
}
