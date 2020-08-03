//
//  RoleDetailViewController.swift
//  Riot
//
//  Created by Naurin Afrin on 3/8/20.
//  Copyright © 2020 matrix.org. All rights reserved.
//

import UIKit

private enum SectionType: Int, CaseIterable {
    case ROLE_PROFILE = 0
    case ROLE_TITLE = 1
    case SPECIALITY = 2
    case LOCATION = 3
    case TEAM = 4
    case ORGANISATION_UNIT = 5
    case PRACTITIONER_ROLE = 6
    
    var cellIdentifier: String {
        switch self {
        case .ROLE_PROFILE:
            return "RoleProfileTableViewCell"
        case .ROLE_TITLE:
            return "RoleTitleTableViewCell"
        case .SPECIALITY:
            return "SpecialityTableViewCell"
        case .LOCATION:
            return "SpecialityTableViewCell"
        case .TEAM:
            return "SpecialityTableViewCell"
        case .ORGANISATION_UNIT:
            return "SpecialityTableViewCell"
        case .PRACTITIONER_ROLE:
            return "PractitionerTableViewCell"
        }
    }
}

class RoleDetailViewController: UIViewController {
    var role: RoleModel?
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
}

// MARK: Private functions
extension RoleDetailViewController {
    private func setupTableView() {
        tableView.delegate = self
        tableView.delaysContentTouches = false
        tableView.dataSource = self
        tableView.allowsSelection = true
        tableView.estimatedRowHeight = 500
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: SectionType.ROLE_PROFILE.cellIdentifier, bundle: nil), forCellReuseIdentifier: SectionType.ROLE_PROFILE.cellIdentifier)
        tableView.register(UINib(nibName: SectionType.ROLE_TITLE.cellIdentifier, bundle: nil), forCellReuseIdentifier: SectionType.ROLE_TITLE.cellIdentifier)
        tableView.register(UINib(nibName: SectionType.SPECIALITY.cellIdentifier, bundle: nil), forCellReuseIdentifier: SectionType.SPECIALITY.cellIdentifier)
        tableView.register(UINib(nibName: SectionType.LOCATION.cellIdentifier, bundle: nil), forCellReuseIdentifier: SectionType.LOCATION.cellIdentifier)
        tableView.register(UINib(nibName: SectionType.TEAM.cellIdentifier, bundle: nil), forCellReuseIdentifier: SectionType.TEAM.cellIdentifier)
        tableView.register(UINib(nibName: SectionType.ORGANISATION_UNIT.cellIdentifier, bundle: nil), forCellReuseIdentifier: SectionType.ORGANISATION_UNIT.cellIdentifier)
        tableView.register(UINib(nibName: SectionType.PRACTITIONER_ROLE.cellIdentifier, bundle: nil), forCellReuseIdentifier: SectionType.PRACTITIONER_ROLE.cellIdentifier)
    }
}

extension RoleDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case SectionType.ROLE_PROFILE.rawValue:
            return 1
        case SectionType.ROLE_TITLE.rawValue:
            return 1
        case SectionType.SPECIALITY.rawValue:
            return 1
        case SectionType.LOCATION.rawValue:
            return 1
        case SectionType.TEAM.rawValue:
            return 1
        case SectionType.ORGANISATION_UNIT.rawValue:
            return 1
        case SectionType.PRACTITIONER_ROLE.rawValue:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case SectionType.ROLE_PROFILE.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SectionType.ROLE_PROFILE.cellIdentifier) as? RoleProfileTableViewCell else { return UITableViewCell() }
            return  cell
        case SectionType.ROLE_TITLE.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SectionType.ROLE_TITLE.cellIdentifier) as? RoleTitleTableViewCell else { return UITableViewCell() }
            return  cell
        case SectionType.SPECIALITY.rawValue, SectionType.LOCATION.rawValue, SectionType.TEAM.rawValue, SectionType.ORGANISATION_UNIT.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SectionType.SPECIALITY.cellIdentifier) as? SpecialityTableViewCell else { return UITableViewCell() }
            return  cell
        case SectionType.PRACTITIONER_ROLE.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SectionType.PRACTITIONER_ROLE.cellIdentifier) as? PractitionerTableViewCell else { return UITableViewCell() }
            return  cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*if(indexPath.section==SectionType.PRACTITIONER_ROLE.rawValue){
            
        }*/
    }
}
