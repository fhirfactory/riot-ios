//
//  ActRoleViewController.swift
//  Riot
//
//  Created by Naurin Afrin on 31/7/20.
//  Copyright © 2020 matrix.org. All rights reserved.
//

import UIKit


private enum SectionType: Int, CaseIterable {
    case FILTER = 0
    case ROLE_CELL = 1
    
    var cellIdentifier: String {
        switch self {
        case .FILTER:
            return "RoleFilterTableViewCell"
        case .ROLE_CELL:
            return "RoleTableViewCell"
        }
    }
}

class ActRoleViewController: UIViewController {
    @IBOutlet weak var rolesTableView: UITableView!
    
    
    // TODO:- This needs to be replaced with appropriate code once the backend is available and can provide role information to the app
    
    var roles = [
        RoleModel(innerRole: Role(name: "ED Acute SRMO", longname: "Senior Resident Medical Officer", id: "na", description: "Emergency Department Acute Senior Resident Medical Officer", designation: "Senior Resident Medical Officer", category: "Emergency", location: "CH {Canberra Hospital}", orgunit: "ED {Emergency Department}"), isExpanded: false),
        RoleModel(innerRole: Role(name: "ED Acute RMO", longname: "Resident Medical Officer", id: "na", description: "Emergency Department Acute Resident Medical Officer", designation: "Resident Medical Officer", category: "Emergency", location: "CH {Canberra Hospital}", orgunit: "ED {Emergency Department}"), isExpanded: false),
        RoleModel(innerRole: Role(name: "ED Acute Intern", longname: "Intern", id: "na", description: "Emergency Department Acute Intern", designation: "Intern", category: "Emergency", location: "CH {Canberra Hospital}", orgunit: "ED {Emergency Department}"), isExpanded: false)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabItem.title = AlternateHomeTools.getNSLocalized("role_title", in: "Vector")
        self.view.accessibilityIdentifier = "RoleVCView"
        ThemeService.shared().theme.recursiveApply(on: self.view)
        rolesTableView.backgroundColor = ThemeService.shared().theme.backgroundColor
        //self.recentsTableView.accessibilityIdentifier = "RoleVCTableView"
        //self.addPlusButton()
        //enableSearchBar = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTableView()
    }
    
}

// MARK: Private functions
extension ActRoleViewController {
    private func setupTableView() {
        rolesTableView.delegate = self
        rolesTableView.delaysContentTouches = false
        rolesTableView.dataSource = self
        rolesTableView.allowsSelection = true
        rolesTableView.estimatedRowHeight = 500
        rolesTableView.rowHeight = UITableView.automaticDimension
        rolesTableView.tableFooterView = UIView()
        rolesTableView.register(UINib(nibName: SectionType.FILTER.cellIdentifier, bundle: nil), forCellReuseIdentifier: SectionType.FILTER.cellIdentifier)
        rolesTableView.register(UINib(nibName: SectionType.ROLE_CELL.cellIdentifier, bundle: nil), forCellReuseIdentifier: SectionType.ROLE_CELL.cellIdentifier)
    }
}

// MARK: UITableViewDataSource
extension ActRoleViewController: UITableViewDataSource, UITableViewDelegate {
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == SectionType.ROLE_CELL.rawValue {
            rolesTableView.deselectRow(at: indexPath, animated: true)
            let vc = RoleDetailViewController() //your view controller
            vc.role = roles[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: Role Cell Delegate
extension ActRoleViewController: RoleCellDelegate {
    func expandButtonClick(cell: RoleTableViewCell, index: Int) {
        UIView.animate(withDuration: 0.3) {
            cell.isDisplayed = !cell.isDisplayed
            self.roles[index].isExpanded = !self.roles[index].isExpanded
        }
        rolesTableView.beginUpdates()
        rolesTableView.endUpdates()
    }
}

// MARK: FilterCell Delegate
extension ActRoleViewController: FilterCellDelegate {
    func moreButtonClick(cell: RoleFilterTableViewCell) {
        UIView.animate(withDuration: 0.3) {
            cell.isDisplayFilter = !cell.isDisplayFilter
        }
        rolesTableView.beginUpdates()
        rolesTableView.endUpdates()
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
