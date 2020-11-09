//
//  RoleFilterTableViewCell.swift
//  Riot
//
//  Created by Naurin Afrin on 2/8/20.
//  Copyright © 2020 matrix.org. All rights reserved.
//

import UIKit


protocol FilterCellDelegate: class {
    func moreButtonClick(cell: RoleFilterTableViewCell)
    func cancelButtonClick()
    func applyButtonClick(search: String?, category: String?, organization: String?, speciality: String?, location: String?)
}

class RoleFilterTableViewCell: UITableViewCell {

    // MARK: IBOutlets
       @IBOutlet weak var searchBar: UISearchBar!
       @IBOutlet weak var moreButton: UIButton!
       @IBOutlet weak var categoryTextField: UITextField!
       @IBOutlet weak var organizationTextField: UITextField!
       @IBOutlet weak var specialityTextField: UITextField!
       @IBOutlet weak var locationTextField: UITextField!
       @IBOutlet weak var filterView: UIView!
       @IBOutlet weak var filterViewHeight: NSLayoutConstraint!
       
       weak var filterDelegate: FilterCellDelegate?
       var isDisplayFilter = false {
           didSet {
               filterView.isHidden = !isDisplayFilter
           }
       }

       override func awakeFromNib() {
           super.awakeFromNib()
           filterView.isHidden = true
       }
       
       @IBAction private func moreButtonClick(_ sender: Any) {
           if let filterDelegate = filterDelegate {
               filterDelegate.moreButtonClick(cell: self)
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
