//
//  RoleTableViewCell.swift
//  Riot
//
//  Created by Naurin Afrin on 2/8/20.
//  Copyright © 2020 matrix.org. All rights reserved.
//

import UIKit


protocol RoleCellDelegate: AnyObject, FavouriteActionReceiverDelegate {
    func expandButtonClick(cell: RoleTableViewCell, index: Int)
}

protocol SelectableRoleCellDelegate: AnyObject {
    func selectionChanged(cell: RoleTableViewCell, index: Int)
}


class RoleTableViewCell: BaseGenericDirectoryCell<RoleModel>, ProvidesReuseIdentifierAndNib {
    //MARK: IBOutlets
    @IBOutlet weak var detailedView: UIView!
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var contactDescription: UILabel!
    @IBOutlet weak var RoleLabel: UILabel!
    @IBOutlet weak var CategoryLabel: UILabel!
    @IBOutlet weak var OrgUnitLabel: UILabel!
    @IBOutlet weak var LocationLabel: UILabel!
    @IBOutlet weak var RoleIcon: MXKImageView!
    @IBOutlet weak var FavouriteButton: UIButton!
    @IBOutlet weak var VideoButton: UIButton!
    @IBOutlet weak var CallButton: UIButton!
    @IBOutlet weak var ChatButton: UIButton!
    @IBOutlet weak var RoleFilledLabel: UILabel!
    @IBOutlet weak var ActionContainer: UIView!
    @IBOutlet weak var SummaryView: UIStackView!
    
    static func getReuseIdentifier() -> String {
        return "RoleTableViewCell"
    }
    
    static func getNib() -> UINib {
        return UINib(nibName: "RoleTableViewCell", bundle: nil)
    }
    
    var role: RoleModel?
    
    weak var delegate: RoleCellDelegate?
    weak var selectableDelegate: SelectableRoleCellDelegate?
    
    var index: Int = 0
    var isDisplayed = false {
        didSet {
            detailedView.isHidden = !isDisplayed
        }
    }
    
    var heightExpanded: CGFloat = 0
    var heightSummary: CGFloat = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        RoleIcon.layer.cornerRadius = RoleIcon.bounds.height / 2
        RoleIcon.clipsToBounds = true
        ThemeService.shared().theme.recursiveApply(on: contentView)
        VideoButton.setTitle(AlternateHomeTools.getNSLocalized("video", in: "Vector"), for: .normal)
        CallButton.setTitle(AlternateHomeTools.getNSLocalized("voice", in: "Vector"), for: .normal)
        ChatButton.setTitle(AlternateHomeTools.getNSLocalized("chat", in: "Vector"), for: .normal)
        layoutIfNeeded()
    }
    
    @IBAction private func expandButtonClick(_ sender: Any) {
        if isDisplayed {
            heightExpanded = frame.height
        } else {
            heightSummary = frame.height
        }
        if let delegate = delegate {
            delegate.expandButtonClick(cell: self, index: index)
        }
    }
    
    @IBAction private func FavouriteToggled(_ sender: Any) {
        if let theRole = role {
            theRole.Favourite = !theRole.Favourite
            if #available(iOS 13.0, *) {
                FavouriteButton.setImage(UIImage(systemName: (theRole.Favourite ? "star.fill" : "star")), for: .normal)
            }
            delegate?.FavouritesUpdated(favourited: theRole.Favourite)
        }
    }
    
    private func roleCommon(role: PractitionerRole) {
        contactName.text = role.shortName
        contactDescription.text = role.longName
        RoleIcon.image = AvatarGenerator.generateAvatar(forText: contactName.text)
        RoleLabel.text = String(format: AlternateHomeTools.getNSLocalized("role_detail_role", in: "Vector"), role.roleName)
        CategoryLabel.text = String(format: AlternateHomeTools.getNSLocalized("role_detail_category", in: "Vector"), role.roleCategory)
        OrgUnitLabel.text = String(format: AlternateHomeTools.getNSLocalized("role_detail_org_unit", in: "Vector"), role.orgName)
        LocationLabel.text = String(format: AlternateHomeTools.getNSLocalized("role_detail_location", in: "Vector"), role.location)
    }
    
    func setActionsHidden(to: Bool) {
        ChatButton.isHidden = to
        CallButton.isHidden = to
        VideoButton.isHidden = to
        RoleFilledLabel.isHidden = to
    }
    
    override func bind(data: RoleModel, index: Int) {
        self.role = data
        self.isDisplayed = data.isExpanded
        self.index = index
        setActionsHidden(to: false)
        
        roleCommon(role: data.innerRole)
        
        if data.isFilled {
            RoleFilledLabel.text = AlternateHomeTools.getNSLocalized("filled", in: "Vector")
            RoleFilledLabel.textColor = ThemeService.shared().theme.tintColor
        } else {
            RoleFilledLabel.text = AlternateHomeTools.getNSLocalized("unfilled", in: "Vector")
            RoleFilledLabel.textColor = ThemeService.shared().theme.warningColor
        }
        
        if #available(iOS 13.0, *) {
            FavouriteButton.setImage(UIImage(systemName: (data.Favourite ? "star.fill" : "star")), for: .normal)
        }
    }
}
