//
//  PeopleDetailViewController.swift
//  Riot
//
//  Created by Naurin Afrin on 5/8/20.
//  Copyright © 2020 matrix.org. All rights reserved.
//

import UIKit


private enum SectionType: Int, CaseIterable {
    case PEOPLE_PROFILE = 0
    case PHONE_CELL = 1
    case EMAIL_CELL = 2
    case ROLE_CELL = 3
    
    var cellIdentifier: String {
        switch self {
        case .PEOPLE_PROFILE:
            return "PeopleProfileTableViewCell"
        case .PHONE_CELL, .EMAIL_CELL:
            return "PhoneTableViewCell"
        case .ROLE_CELL:
            return "RoleTableViewCell"
        }
    }
}

class PeopleDetailViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var actPeople: ActPeople?
    
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
        setupTableView()
    }
    
    
}

// MARK: Private functions
extension PeopleDetailViewController {
    private func setupTableView() {
        tableView.delegate = self
        tableView.delaysContentTouches = false
        tableView.dataSource = self
        tableView.allowsSelection = true
        tableView.estimatedRowHeight = 500
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: SectionType.PEOPLE_PROFILE.cellIdentifier, bundle: nil), forCellReuseIdentifier: SectionType.PEOPLE_PROFILE.cellIdentifier)
        tableView.register(UINib(nibName: SectionType.PHONE_CELL.cellIdentifier, bundle: nil), forCellReuseIdentifier: SectionType.PHONE_CELL.cellIdentifier)
        tableView.register(UINib(nibName: SectionType.ROLE_CELL.cellIdentifier, bundle: nil), forCellReuseIdentifier: SectionType.ROLE_CELL.cellIdentifier)
    }
}

extension PeopleDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case SectionType.PEOPLE_PROFILE.rawValue:
            return 1
        case SectionType.PHONE_CELL.rawValue:
            return 1
        case SectionType.EMAIL_CELL.rawValue:
            return 1
        case SectionType.ROLE_CELL.rawValue:
            return roles.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case SectionType.PEOPLE_PROFILE.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SectionType.PEOPLE_PROFILE.cellIdentifier) as? PeopleProfileTableViewCell else { return UITableViewCell() }
            return  cell
        case SectionType.PHONE_CELL.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SectionType.PHONE_CELL.cellIdentifier) as? PhoneTableViewCell else { return UITableViewCell() }
            return  cell
        case SectionType.EMAIL_CELL.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SectionType.EMAIL_CELL.cellIdentifier) as? PhoneTableViewCell else { return UITableViewCell() }
            return  cell
        case SectionType.ROLE_CELL.rawValue:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SectionType.ROLE_CELL.cellIdentifier) as? RoleTableViewCell else { return UITableViewCell() }
                cell.delegate = self
                cell.bindModel(role: roles[indexPath.row], index: indexPath.row)
                return  cell
        default:
            return UITableViewCell()
        }
    }
}

// MARK: Role Cell Delegate
extension PeopleDetailViewController: RoleCellDelegate {
    func expandButtonClick(cell: RoleTableViewCell, index: Int) {
        UIView.animate(withDuration: 0.3) {
            cell.isDisplayed = !cell.isDisplayed
            self.roles[index].isExpanded = !self.roles[index].isExpanded
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
