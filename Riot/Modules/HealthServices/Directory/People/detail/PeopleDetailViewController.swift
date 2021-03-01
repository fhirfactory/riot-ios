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
    case FAVOURITE_CELL = 1
    case PHONE_CELL = 2
    case EMAIL_CELL = 3
    case ROLE_CELL = 4
    
    var cellIdentifier: String {
        switch self {
        case .PEOPLE_PROFILE:
            return "PeopleProfileTableViewCell"
        case .PHONE_CELL:
            return "PhoneTableViewCell"
        case .FAVOURITE_CELL:
            return "DetailFavouriteTableViewCell"
        case .EMAIL_CELL:
            return "EmailTableViewCell"
        case .ROLE_CELL:
            return "RoleTableViewCell"
        }
    }
}

class PeopleDetailViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var actPeople: ActPeopleModel?
    
    var rolesLoaded: Bool = false
    
    // TODO:- This needs to be replaced with appropriate code once the backend is available and can provide role information to the app
    private var _roles: [RoleModel] = []
    var roles: [RoleModel] {
        get {
            return _roles
        }
        set(value) {
            _roles = value
            rolesLoaded = true
            if tableView != nil {
                tableView.reloadSections(IndexSet(integer: SectionType.ROLE_CELL.rawValue), with: .automatic)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    func setPerson(person: ActPeopleModel) {
        actPeople = person
        self.navigationItem.title = person.officialName
        Services.PractitionerRoleService().GetRolesForUser(queryDetails: person.baseUser) { (roles) in
            self.roles = roles.map({role in
                return RoleModel(innerRole: role, isExpanded: false)
            })
        } failure: {
            
        }

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
        tableView.register(UINib(nibName: SectionType.EMAIL_CELL.cellIdentifier, bundle: nil), forCellReuseIdentifier: SectionType.EMAIL_CELL.cellIdentifier)
        tableView.register(UINib(nibName: SectionType.FAVOURITE_CELL.cellIdentifier, bundle: nil), forCellReuseIdentifier: SectionType.FAVOURITE_CELL.cellIdentifier)
        tableView.register(UINib(nibName: "LoadingDataTableViewCell", bundle: nil), forCellReuseIdentifier: "LoadingDataTableViewCell")
        tableView.backgroundColor = ThemeService.shared().theme.backgroundColor
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
        case SectionType.FAVOURITE_CELL.rawValue:
            return 1
        case SectionType.PHONE_CELL.rawValue:
            return 1
        case SectionType.EMAIL_CELL.rawValue:
            return 1
        case SectionType.ROLE_CELL.rawValue:
            return rolesLoaded ? roles.count : 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case SectionType.EMAIL_CELL.rawValue:
            guard actPeople != nil else { return }
            guard let url = URL(string: "mailto:\(actPeople?.emailAddress ?? "")") else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        case SectionType.ROLE_CELL.rawValue:
            tableView.deselectRow(at: indexPath, animated: true)
            let vc = RoleDetailViewController() //your view controller
            vc.role = roles[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let person = actPeople else { return UITableViewCell() }
        switch indexPath.section {
        case SectionType.PEOPLE_PROFILE.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SectionType.PEOPLE_PROFILE.cellIdentifier) as? PeopleProfileTableViewCell else { return UITableViewCell() }
            cell.setPerson(person: person)
            return cell
        case SectionType.FAVOURITE_CELL.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SectionType.FAVOURITE_CELL.cellIdentifier) as? DetailFavouriteTableViewCell else { return UITableViewCell() }
            cell.FavouritesDelegate = self
            cell.itemTypeString = AlternateHomeTools.getNSLocalized("person_title", in: "Vector")
            cell.Render()
            return cell
        case SectionType.PHONE_CELL.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SectionType.PHONE_CELL.cellIdentifier) as? PhoneTableViewCell else { return UITableViewCell() }
            if let number = person.phoneNumber {
                cell.setNumber(number: number)
            }
            return cell
        case SectionType.EMAIL_CELL.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SectionType.EMAIL_CELL.cellIdentifier) as? EmailTableViewCell else { return UITableViewCell() }
            cell.setUser(person: person)
            return cell
        case SectionType.ROLE_CELL.rawValue:
            if rolesLoaded {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SectionType.ROLE_CELL.cellIdentifier) as? RoleTableViewCell else { return UITableViewCell() }
                cell.delegate = self
                cell.bindModel(role: roles[indexPath.row], index: indexPath.row)
                return cell
            }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingDataTableViewCell") as? LoadingDataTableViewCell else { return UITableViewCell() }
            return cell
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
    func favouritesUpdated(favourited: Bool) {
        // TODO:- this function needs to be implemented with back-end data storage
    }
}

extension PeopleDetailViewController: DetailFavouriteTableCellDelegate {
    var IsFavourite: Bool {
        get {
            actPeople?.Favourite == true
        }
        set(val) {
            actPeople?.Favourite = val
        }
    }
}
