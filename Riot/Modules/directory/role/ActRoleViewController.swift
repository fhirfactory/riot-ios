//
//  ActRoleViewController.swift
//  Riot
//
//  Created by Naurin Afrin on 31/7/20.
//  Copyright © 2020 matrix.org. All rights reserved.
//

import UIKit


private enum SectionType: Int, CaseIterable {
    case FILTER
    case ROLE_CELL
    
    var cellIdentifier: String {
        switch self {
        case .FILTER:
            return "RoleFilterTableViewCell"
        case .ROLE_CELL:
            return "RoleTableViewCell"
        }
    }
}

class ActRoleViewController: RecentsViewController {
    
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
        tabItem.title = NSLocalizedString("role_title", tableName: "Act", comment: "")
        self.view.accessibilityIdentifier = "RoleVCView"
        self.recentsTableView.accessibilityIdentifier = "RoleVCTableView"
        //self.addPlusButton()
        enableSearchBar = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTableView()
    }
    
}

// MARK: Private functions
extension ActRoleViewController {
    private func setupTableView() {
        recentsTableView.delegate = self
        recentsTableView.delaysContentTouches = false
        recentsTableView.dataSource = self
        recentsTableView.allowsSelection = true
        recentsTableView.estimatedRowHeight = 500
        recentsTableView.rowHeight = UITableView.automaticDimension
        recentsTableView.tableFooterView = UIView()
        recentsTableView.register(UINib(nibName: SectionType.FILTER.cellIdentifier, bundle: nil), forCellReuseIdentifier: SectionType.FILTER.cellIdentifier)
        recentsTableView.register(UINib(nibName: SectionType.ROLE_CELL.cellIdentifier, bundle: nil), forCellReuseIdentifier: SectionType.ROLE_CELL.cellIdentifier)
    }
}

// MARK: UITableViewDataSource
extension ActRoleViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == SectionType.FILTER.rawValue {
            return 1
        }
        return roles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SectionType.FILTER.rawValue {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SectionType.FILTER.cellIdentifier) as? RoleFilterTableViewCell else { return UITableViewCell() }
            cell.filterDelegate = self
            return cell
        }
        guard let roleCell = tableView.dequeueReusableCell(withIdentifier: SectionType.ROLE_CELL.cellIdentifier, for: indexPath) as? RoleTableViewCell else { return UITableViewCell() }
        roleCell.delegate = self
        roleCell.bindModel(role: roles[indexPath.row], index: indexPath.row)
        return roleCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let role = roles[indexPath.row]
        print(role.name)
    }
    
}

// MARK: Role Cell Delegate
extension ActRoleViewController: RoleCellDelegate {
    func expandButtonClick(cell: RoleTableViewCell, index: Int) {
        UIView.animate(withDuration: 0.3) {
            cell.isDisplayed = !cell.isDisplayed
            self.roles[index].isExpanded = !self.roles[index].isExpanded
        }
        recentsTableView.beginUpdates()
        recentsTableView.endUpdates()
    }
}

// MARK: FilterCell Delegate
extension ActRoleViewController: FilterCellDelegate {
    func moreButtonClick(cell: RoleFilterTableViewCell) {
        UIView.animate(withDuration: 0.3) {
            cell.isDisplayFilter = !cell.isDisplayFilter
        }
        recentsTableView.beginUpdates()
        recentsTableView.endUpdates()
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
