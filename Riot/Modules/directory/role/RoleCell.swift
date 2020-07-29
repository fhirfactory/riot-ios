//
//  RoleCell.swift
//  Riot
//
//  Created by Naurin Afrin on 29/7/20.
//  Copyright © 2020 matrix.org. All rights reserved.
//

import UIKit

protocol RoleCellDelegate: class {
    func expandButtonClick(cell: RoleCell, index: Int)
}

class RoleCell: UITableViewCell {

    weak var delegate: RoleCellDelegate?
    var index: Int = 0
    var isDisplayed = false {
        didSet {
            detailedView.isHidden = !isDisplayed
        }
    }
    
    @IBOutlet weak var detailedView: UIView!

    
    @IBAction private func expandButtonClick(_ sender: Any) {
        if let delegate = delegate {
            delegate.expandButtonClick(cell: self, index: index)
        }
    }
    
    func bindModel(role: RoleModel, index: Int) {
        self.isDisplayed = role.isExpanded
        self.index = index
    }

}
