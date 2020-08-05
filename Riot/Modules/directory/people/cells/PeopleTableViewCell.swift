//
//  PeopleTableViewCell.swift
//  Riot
//
//  Created by Naurin Afrin on 5/8/20.
//  Copyright © 2020 matrix.org. All rights reserved.
//

import UIKit


protocol PeopleCellDelegate {
    func favoriteButtonClick(actPeople: ActPeople?)
}

class PeopleTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var businessUnit: PaddingLabel!
    @IBOutlet weak var organisation: PaddingLabel!
    
    var peopleCellDelegate: PeopleCellDelegate?
    var actPeople: ActPeople?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func favoriteButtonTap(_ sender: Any) {
        if let delegate = peopleCellDelegate{
            delegate.favoriteButtonClick(actPeople: actPeople)
        }
    }
    
    func setValue(actPeople: ActPeople) {
        self.actPeople = actPeople
    }
}
