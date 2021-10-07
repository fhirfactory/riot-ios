//
//  EmailTableViewCell.swift
//  Riot
//
//  Created by Joseph Fergusson on 12/10/20.
//  Copyright © 2020 matrix.org. All rights reserved.
//

import Foundation

class EmailTableViewCell: UITableViewCell {
    @IBOutlet weak var Header: UILabel!
    @IBOutlet weak var Value: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ThemeService.shared().theme.recursiveApply(on: self.contentView)
    }
    
    func setUser(person: Practitioner){
        Value.text = person.emailAddress
    }
}
