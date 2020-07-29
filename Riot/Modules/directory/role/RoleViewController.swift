//
//  RoleViewController.swift
//  Riot
//
//  Created by Naurin Afrin on 29/7/20.
//  Copyright © 2020 matrix.org. All rights reserved.
//

import UIKit

struct RoleModel {
    var name: String
    var description: String
    var isExpanded: Bool
}

class RoleViewController: UIViewController {

   @IBOutlet weak var tableView: UITableView!
        
        var roles = [
            RoleModel(name: "Test", description: "Emergency Department", isExpanded: false),
            RoleModel(name: "Test", description: "Emergency Department", isExpanded: false),
            RoleModel(name: "Test", description: "Emergency Department", isExpanded: false),
            RoleModel(name: "Test", description: "Emergency Department", isExpanded: false),
            RoleModel(name: "Test", description: "Emergency Department", isExpanded: false),
            RoleModel(name: "Test", description: "Emergency Department", isExpanded: false),
            RoleModel(name: "Test", description: "Emergency Department", isExpanded: false),
            RoleModel(name: "Test", description: "Emergency Department", isExpanded: false),
            RoleModel(name: "Test", description: "Emergency Department", isExpanded: false),
            RoleModel(name: "Test", description: "Emergency Department", isExpanded: false),
            RoleModel(name: "Test", description: "Emergency Department", isExpanded: false),
            RoleModel(name: "Test", description: "Emergency Department", isExpanded: false),
            RoleModel(name: "Test", description: "Emergency Department", isExpanded: false)
        ]
        
        override func viewDidLoad() {
            super.viewDidLoad()
            tableView.delegate = nil
            tableView.dataSource = self
            tableView.estimatedRowHeight = 500
            tableView.rowHeight = UITableView.automaticDimension
            tableView.tableFooterView = UIView()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            AppDelegate.the()?.masterTabBarController.navigationItem.title = NSLocalizedString("title_people", tableName: "Vector", comment: "")
            AppDelegate.the().masterTabBarController.tabBar.tintColor = ThemeService.shared().theme.tintColor
        }

    }

    // MARK: UITableViewDataSource
    extension RoleViewController: UITableViewDataSource {
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 2
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if section == 0 {
                return 1
            }
            return roles.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if indexPath.section == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "filterCell") as? RoleFilterCell else { return UITableViewCell() }
                cell.filterDelegate = self
                return cell
            }
            guard let roleCell = tableView.dequeueReusableCell(withIdentifier: "roleCell", for: indexPath) as? RoleCell else { return UITableViewCell() }
            roleCell.delegate = self
            roleCell.bindModel(role: roles[indexPath.row], index: indexPath.row)
            return roleCell
        }
        
    }
    // MARK: Role Cell Delegate
    extension RoleViewController: RoleCellDelegate {
        func expandButtonClick(cell: RoleCell, index: Int) {
            UIView.animate(withDuration: 0.3) {
                cell.isDisplayed = !cell.isDisplayed
                self.roles[index].isExpanded = !self.roles[index].isExpanded
            }
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }

    // MARK: FilterCell Delegate
    extension RoleViewController: RoleFilterCellDelegate {
        func moreButtonClick() {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        
        func cancelButtonClick() {
            
        }
        
        func applyButtonClick(search: String?,
                              category: String?,
                              organization: String?,
                              speciality: String?,
                              location: String?) {
            
        }
        
        
    }
