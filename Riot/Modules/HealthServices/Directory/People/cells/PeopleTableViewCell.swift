//
//  PeopleTableViewCell.swift
//  Riot
//
//  Created by Naurin Afrin on 5/8/20.
//  Copyright © 2020 matrix.org. All rights reserved.
//

import UIKit

class PeopleTableViewCell: BaseGenericDirectoryCell<ActPeopleModel>, ProvidesReuseIdentifierAndNib {
    static func getReuseIdentifier() -> String {
        "PeopleTableViewCell"
    }
    
    static func getNib() -> UINib {
        UINib(nibName: "PeopleTableViewCell", bundle: nil)
    }
    

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var businessUnit: PaddingLabel!
    @IBOutlet weak var organisation: PaddingLabel!
    @IBOutlet weak var FavouriteButton: UIButton!
    @IBOutlet weak var AvatarImage: MXKImageView!
    
    var peopleCellDelegate: FavouriteActionReceiverDelegate?
    var actPeopleModel: ActPeopleModel?
    private var _actPerson: ActPeopleModel? = nil
    var actPerson: ActPeopleModel? {
        get {
            guard let p = _actPerson else { return actPeopleModel }
            return p
        }
        set(value) {
            _actPerson = value
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction private func favoriteButtonTap(_ sender: Any) {
        guard let person = actPeopleModel else { return }
        person.Favourite = !person.Favourite
        if #available(iOS 13.0, *) {
            FavouriteButton.setImage(UIImage(systemName: (person.Favourite ? "star.fill" : "star")), for: .normal)
        } else {
            // Fallback on earlier versions
        }
        peopleCellDelegate?.FavouritesUpdated(favourited: person.Favourite)
    }
    
    override func bind(data: ActPeopleModel, index: Int) {
        setValue(actPeople: data)
    }
    
    func bind(practitioner: Practitioner) {
        setValue(actPeople: ActPeopleModel(innerPractitioner: practitioner))
    }
    
    func setValue(actPeople: ActPeopleModel, displayFavourites: Bool = true) {
        self.actPeopleModel = actPeople
        name.text = actPeople.displayName
        jobTitle.text = actPeople.jobTitle
        businessUnit.text = actPeople.businessUnit
        organisation.text = actPeople.organisation
        FavouriteButton.isHidden = !displayFavourites
        AvatarImage.enableInMemoryCache = true
        AvatarImage.setImageURI(actPeople.avatarURL, withType: nil, andImageOrientation: UIImage.Orientation.up, previewImage: AvatarGenerator.generateAvatar(forText: actPeople.displayName), mediaManager: (AppDelegate.theDelegate().mxSessions.first as? MXSession)?.mediaManager)
        AvatarImage.layer.cornerRadius = AvatarImage.frame.width / 2
        AvatarImage.layer.masksToBounds = true
        var currentTheme = ThemeService.shared().theme
        if BuildSettings.settingsScreenOverrideDefaultThemeSelection != "" {
            currentTheme = ThemeService.shared().theme(withThemeId: BuildSettings.settingsScreenOverrideDefaultThemeSelection as String)
        }
        backgroundColor = currentTheme.backgroundColor
        
        AvatarImage.backgroundColor = currentTheme.backgroundColor
        
        jobTitle.textColor = currentTheme.textPrimaryColor
        businessUnit.textColor = currentTheme.textPrimaryColor
        organisation.textColor = currentTheme.textPrimaryColor
        name.textColor = currentTheme.textPrimaryColor
        
        if #available(iOS 13.0, *) {
            FavouriteButton.setImage(UIImage(systemName: (actPeople.Favourite ? "star.fill" : "star")), for: .normal)
        } else {
            // Fallback on earlier versions
        }
    }
}
