//
//  RoleTableViewCell.swift
//  Riot
//
//  Created by Naurin Afrin on 2/8/20.
//  Copyright © 2020 matrix.org. All rights reserved.
//

import UIKit


protocol RoleCellDelegate: class {
    func expandButtonClick(cell: RoleTableViewCell, index: Int)
}


class RoleTableViewCell: UITableViewCell {
    //MARK: IBOutlets
    @IBOutlet weak var detailedView: UIView!
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var contactDescription: UILabel!
    @IBOutlet weak var RoleLabel: UILabel!
    @IBOutlet weak var CategoryLabel: UILabel!
    @IBOutlet weak var OrgUnitLabel: UILabel!
    @IBOutlet weak var LocationLabel: UILabel!
    @IBOutlet weak var RoleIcon: MXKImageView!
    
    weak var delegate: RoleCellDelegate?
    var index: Int = 0
    var isDisplayed = false {
        didSet {
            detailedView.isHidden = !isDisplayed
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        RoleIcon.layer.cornerRadius = RoleIcon.bounds.height / 2
        RoleIcon.clipsToBounds = true
        ThemeService.shared().theme.recursiveApply(on: contentView)
    }
    
    @IBAction private func expandButtonClick(_ sender: Any) {
        if let delegate = delegate {
            delegate.expandButtonClick(cell: self, index: index)
        }
    }
    
    func bindModel(role: RoleModel, index: Int) {
        self.isDisplayed = role.isExpanded
        self.index = index
        contactName.text = role.innerRole.Name
        contactDescription.text = role.innerRole.OfficialName
        RoleIcon.image = AvatarGenerator.generateAvatar(forText: contactName.text)
        RoleLabel.text = String(format: AlternateHomeTools.getNSLocalized("role_detail_role", in: "Vector"), role.innerRole.Title)
        CategoryLabel.text = String(format: AlternateHomeTools.getNSLocalized("role_detail_category", in: "Vector"), role.innerRole.Category)
        OrgUnitLabel.text = String(format: AlternateHomeTools.getNSLocalized("role_detail_org_unit", in: "Vector"), role.innerRole.OrgUnit)
        LocationLabel.text = String(format: AlternateHomeTools.getNSLocalized("role_detail_location", in: "Vector"), role.innerRole.Location)
    }
}
