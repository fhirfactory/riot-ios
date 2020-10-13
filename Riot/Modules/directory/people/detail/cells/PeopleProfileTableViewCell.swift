//
//  PeopleProfileTableViewCell.swift
//  Riot
//
//  Created by Naurin Afrin on 5/8/20.
//  Copyright © 2020 matrix.org. All rights reserved.
//

import UIKit

class PeopleProfileTableViewCell: UITableViewCell {
    
    var person: ActPeople!
    @IBOutlet weak var avatar: MXKImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var organisation: UILabel!
    @IBOutlet weak var businessUnit: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    @IBAction private func StartChatOption(_ sender: Any) {
        AppDelegate.the()?.startDirectChat(withUserId: person.baseUser.userId, completion: {
            
        })
    }
    @IBAction private func StartAudioCallOption(_ sender: Any) {
        
    }
    @IBAction private func StartVideoCallOption(_ sender: Any) {
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setPerson(person: ActPeople) {
        self.person = person
        name.text = person.officialName
        jobTitle.text = person.jobTitle
        organisation.text = person.organisation
        businessUnit.text = person.businessUnit
        avatar.setImageURI(person.baseUser.avatarUrl, withType: nil, andImageOrientation: UIImage.Orientation.up, previewImage: AvatarGenerator.generateAvatar(forText: person.officialName), mediaManager: (AppDelegate.the()?.mxSessions.first as? MXSession)?.mediaManager)
        avatar.layer.cornerRadius = avatar.frame.width / 2
        avatar.layer.masksToBounds = true
    }
    
}
