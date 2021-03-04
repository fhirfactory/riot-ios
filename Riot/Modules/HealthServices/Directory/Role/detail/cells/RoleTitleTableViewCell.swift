//
//  RoleTitleTableViewCell.swift
//  Riot
//
//  Created by Naurin Afrin on 3/8/20.
//  Copyright © 2020 matrix.org. All rights reserved.
//

import UIKit

class RoleTitleTableViewCell: UITableViewCell {

    @IBOutlet weak var heading: UILabel!
    @IBOutlet weak var primaryText: UILabel!
    @IBOutlet weak var secondaryText: UILabel!
    var Role: Role!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ThemeService.shared().theme.recursiveApply(on: self.contentView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setRole(role: Role?)  {
        Role = role
        heading.text = AlternateHomeTools.getNSLocalized("role_title", in: "Vector")
        primaryText.text = Role?.Title
    }
}
