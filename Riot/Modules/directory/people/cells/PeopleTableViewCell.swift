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
    @IBOutlet weak var FavouritesButton: UIButton!
    @IBOutlet weak var AvatarImage: MXKImageView!
    
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
    
    func setValue(actPeople: ActPeople, displayFavourites: Bool = true) {
        self.actPeople = actPeople
        name.text = actPeople.officialName
        jobTitle.text = actPeople.jobTitle
        businessUnit.text = actPeople.businessUnit
        organisation.text = actPeople.organisation
        FavouritesButton.isHidden = !displayFavourites
        AvatarImage.setImageURI(actPeople.baseUser.avatarUrl, withType: nil, andImageOrientation: UIImage.Orientation.up, previewImage: AvatarGenerator.generateAvatar(forText: actPeople.officialName), mediaManager: (AppDelegate.theDelegate().mxSessions.first as? MXSession)?.mediaManager)
        AvatarImage.layer.cornerRadius = AvatarImage.frame.width / 2
        AvatarImage.layer.masksToBounds = true
    }
}
