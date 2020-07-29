//
//  RoleFilterCell.swift
//  Riot
//
//  Created by Naurin Afrin on 29/7/20.
//  Copyright © 2020 matrix.org. All rights reserved.
//

import UIKit

protocol RoleFilterCellDelegate: class {
    func moreButtonClick()
    func cancelButtonClick()
    func applyButtonClick(search: String?, category: String?, organization: String?, speciality: String?, location: String?)
}

class RoleFilterCell: UITableViewCell {

    @IBOutlet weak var searchBar: UISearchBar!
     @IBOutlet weak var moreButton: UIButton!
     @IBOutlet weak var categoryTextField: UITextField!
     @IBOutlet weak var organizationTextField: UITextField!
     @IBOutlet weak var specialityTextField: UITextField!
     @IBOutlet weak var locationTextField: UITextField!
     @IBOutlet weak var filterView: UIView!
     
     @IBOutlet weak var filterViewHeight: NSLayoutConstraint!
     weak var filterDelegate: RoleFilterCellDelegate?
     var isDisplayFilter = false
     
     @IBAction private func moreButtonClick(_ sender: Any) {
         if let filterDelegate = filterDelegate {
             
             UIView.animate(withDuration: 0.3) {
                 if !self.isDisplayFilter {
                     self.filterViewHeight.constant = 290
                 } else {
                     self.filterViewHeight.constant = 0
                 }
                 filterDelegate.moreButtonClick()
             }
             isDisplayFilter = !isDisplayFilter
         }
         
     }
     
     @IBAction private func cancelButtonClick(_ sender: Any) {
         if let filterDelegate = filterDelegate {
             filterDelegate.cancelButtonClick()
         }
     }
     
     @IBAction private func applyButtonClick(_ sender: Any) {
         if let filterDelegate = filterDelegate {
             filterDelegate.applyButtonClick(search: searchBar.text,
                                             category: categoryTextField.text,
                                             organization: organizationTextField.text,
                                             speciality: specialityTextField.text,
                                             location: locationTextField.text)
         }
     }
}
