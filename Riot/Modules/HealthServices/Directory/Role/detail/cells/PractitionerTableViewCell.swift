//
//  PractitionerTableViewCell.swift
//  Riot
//
//  Created by Naurin Afrin on 3/8/20.
//  Copyright © 2020 matrix.org. All rights reserved.
//

import UIKit

class PractitionerTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarView: MXKImageView!
    @IBOutlet weak var primaryText: UILabel!
    @IBOutlet weak var secondaryText: UILabel!
    
    var user: ActPeopleModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ThemeService.shared().theme.recursiveApply(on: self.contentView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setUser(_ person: ActPeopleModel) {
        user = person
        avatarView.setImageURI(person.baseUser.avatarUrl, withType: nil, andImageOrientation: UIImage.Orientation.up, previewImage: AvatarGenerator.generateAvatar(forText: person.officialName), mediaManager: (AppDelegate.theDelegate().mxSessions.first as? MXSession)?.mediaManager)
        avatarView.layer.cornerRadius = avatarView.frame.height / 2
        avatarView.clipsToBounds = true
        primaryText.text = person.officialName
        secondaryText.text = person.jobTitle
    }
}
