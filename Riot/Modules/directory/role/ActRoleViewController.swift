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
    @IBOutlet weak var recentsTableView: UITableView!
    
    var roles = [
        RoleModel(name: "Test1", description: "Emergency Department", isExpanded: false),
        RoleModel(name: "Test2", description: "Emergency Department", isExpanded: false),
        RoleModel(name: "Test3", description: "Emergency Department", isExpanded: false),
        RoleModel(name: "Test4", description: "Emergency Department", isExpanded: false),
        RoleModel(name: "Test5", description: "Emergency Department", isExpanded: false),
        RoleModel(name: "Test6", description: "Emergency Department", isExpanded: false),
        RoleModel(name: "Test7", description: "Emergency Department", isExpanded: false),
        RoleModel(name: "Test8", description: "Emergency Department", isExpanded: false),
        RoleModel(name: "Test9", description: "Emergency Department", isExpanded: false),
        RoleModel(name: "Test10", description: "Emergency Department", isExpanded: false),
        RoleModel(name: "Test11", description: "Emergency Department", isExpanded: false),
        RoleModel(name: "Test12", description: "Emergency Department", isExpanded: false),
        RoleModel(name: "Test13", description: "Emergency Department", isExpanded: false)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabItem.title = NSLocalizedString("role_title", tableName: "Act", comment: "")
        self.view.accessibilityIdentifier = "RoleVCView"
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
        if(indexPath.section == SectionType.ROLE_CELL.rawValue) {
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
