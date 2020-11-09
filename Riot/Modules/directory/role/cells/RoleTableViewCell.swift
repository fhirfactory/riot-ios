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
       @IBOutlet weak var contactIcon: UILabel!
       @IBOutlet weak var detailedView: UIView!
       @IBOutlet weak var contactName: UILabel!
       @IBOutlet weak var contactDescription: UILabel!
       @IBOutlet weak var roleLabel: PaddingLabel!
       @IBOutlet weak var specialityLabel: PaddingLabel!
       @IBOutlet weak var locationLabel: PaddingLabel!
       
       weak var delegate: RoleCellDelegate?
       var index: Int = 0
       var isDisplayed = false {
           didSet {
               detailedView.isHidden = !isDisplayed
           }
       }
       
       override func awakeFromNib() {
           super.awakeFromNib()
           contactIcon.layer.cornerRadius = contactIcon.bounds.height / 2
           contactIcon.clipsToBounds = true
       }
       
       @IBAction private func expandButtonClick(_ sender: Any) {
           if let delegate = delegate {
               delegate.expandButtonClick(cell: self, index: index)
           }
       }
       
       func bindModel(role: RoleModel, index: Int) {
           self.isDisplayed = role.isExpanded
           self.index = index
           contactName.text = role.name
           contactDescription.text = role.description
       }
}
