//
//  RoleProfileTableViewCell.swift
//  Riot
//
//  Created by Naurin Afrin on 3/8/20.
//  Copyright © 2020 matrix.org. All rights reserved.
//

import UIKit

class RoleProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var officialName: UILabel!
    @IBOutlet weak var jobTitle: UILabel!
    var Role: PractitionerRole!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ThemeService.shared().theme.recursiveApply(on: self.contentView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setRole(role: PractitionerRole?) {
        Role = role
        officialName.text = role?.displayName
        jobTitle.text = role?.roleName
    }
}
