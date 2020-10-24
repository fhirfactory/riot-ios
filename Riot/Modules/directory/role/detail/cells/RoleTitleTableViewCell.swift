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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setValue()  {
        
    }
}
