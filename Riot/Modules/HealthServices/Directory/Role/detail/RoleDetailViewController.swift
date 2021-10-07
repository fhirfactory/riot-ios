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
    case FAVOURITE = 1
    case ROLE_TITLE = 2
    case SPECIALITY = 3
    case LOCATION = 4
    case ORGANISATION_UNIT = 5
    case PRACTITIONER_ROLE = 6
    
    var cellIdentifier: String {
        switch self {
        case .ROLE_PROFILE:
            return "RoleProfileTableViewCell"
        case .FAVOURITE:
            return "DetailFavouriteTableViewCell"
        case .ROLE_TITLE:
            return "RoleTitleTableViewCell"
        case .SPECIALITY, .LOCATION, .ORGANISATION_UNIT:
            return "TitleSubtitleTableViewCell"
        case .PRACTITIONER_ROLE:
            return "PractitionerTableViewCell"
        }
    }
}

class RoleDetailViewController: UIViewController {
    private var _role: RoleModel?
    private var practitionersLoaded: Bool = false
    var role: RoleModel? {
        get {
            return _role
        }
        set(value) {
            _role = value
            self.navigationItem.title = value?.longName
            if let v = value {
                /*Services.RolePractitionerService().GetUsersForRole(queryDetails: v) { (practitioners) in
                    self.practitioners = practitioners.map({ (p) in
                        ActPeopleModel(innerPractitioner: p)
                    })
                } failure: {
                    self.practitioners = []
                }*/
            }
        }
    }
    private var _practitioners: [ActPeopleModel] = []
    var practitioners: [ActPeopleModel] {
        get {
            return _practitioners
        }
        set(value) {
            _practitioners = value
            practitionersLoaded = true
            if tableView != nil {
                tableView.reloadSections(IndexSet(integer: SectionType.PRACTITIONER_ROLE.rawValue), with: .automatic)
            }
        }
    }
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        ThemeService.shared().theme.recursiveApply(on: self.view)
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
        tableView.register(UINib(nibName: SectionType.FAVOURITE.cellIdentifier, bundle: nil), forCellReuseIdentifier: SectionType.FAVOURITE.cellIdentifier)
        tableView.register(UINib(nibName: SectionType.ROLE_TITLE.cellIdentifier, bundle: nil), forCellReuseIdentifier: SectionType.ROLE_TITLE.cellIdentifier)
        tableView.register(UINib(nibName: SectionType.SPECIALITY.cellIdentifier, bundle: nil), forCellReuseIdentifier: SectionType.SPECIALITY.cellIdentifier)
        tableView.register(UINib(nibName: SectionType.LOCATION.cellIdentifier, bundle: nil), forCellReuseIdentifier: SectionType.LOCATION.cellIdentifier)
        tableView.register(UINib(nibName: SectionType.ORGANISATION_UNIT.cellIdentifier, bundle: nil), forCellReuseIdentifier: SectionType.ORGANISATION_UNIT.cellIdentifier)
        tableView.register(UINib(nibName: SectionType.PRACTITIONER_ROLE.cellIdentifier, bundle: nil), forCellReuseIdentifier: SectionType.PRACTITIONER_ROLE.cellIdentifier)
        tableView.register(UINib(nibName: "LoadingDataTableViewCell", bundle: nil), forCellReuseIdentifier: "LoadingDataTableViewCell")
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
        case SectionType.FAVOURITE.rawValue:
            return 1
        case SectionType.ROLE_TITLE.rawValue:
            return 1
        case SectionType.SPECIALITY.rawValue:
            return 1
        case SectionType.LOCATION.rawValue:
            return 1
        case SectionType.ORGANISATION_UNIT.rawValue:
            return 1
        case SectionType.PRACTITIONER_ROLE.rawValue:
            return practitionersLoaded ? practitioners.count : 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case SectionType.ROLE_PROFILE.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SectionType.ROLE_PROFILE.cellIdentifier) as? RoleProfileTableViewCell else { return UITableViewCell() }
            cell.setRole(role: role?.innerRole)
            return  cell
        case SectionType.FAVOURITE.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SectionType.FAVOURITE.cellIdentifier) as? DetailFavouriteTableViewCell else { return UITableViewCell() }
            cell.FavouritesDelegate = self
            cell.itemTypeString = AlternateHomeTools.getNSLocalized("role_title", in: "Vector")
            cell.Render()
            return cell
        case SectionType.ROLE_TITLE.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SectionType.ROLE_TITLE.cellIdentifier) as? RoleTitleTableViewCell else { return UITableViewCell() }
            cell.setRole(role: role?.innerRole)
            return  cell
        case SectionType.SPECIALITY.rawValue, SectionType.LOCATION.rawValue, SectionType.ORGANISATION_UNIT.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SectionType.SPECIALITY.cellIdentifier) as? TitleSubtitleTableViewCell else { return UITableViewCell() }
            switch indexPath.section {
            case SectionType.SPECIALITY.rawValue:
                cell.DrawCell(withTitle: AlternateHomeTools.getNSLocalized("role_detail_specialty_title", in: "Vector"), andSubtitle: role?.roleCategory)
            case SectionType.LOCATION.rawValue:
                cell.DrawCell(withTitle: AlternateHomeTools.getNSLocalized("role_detail_location_title", in: "Vector"), andSubtitle: role?.location)
            case SectionType.ORGANISATION_UNIT.rawValue:
                cell.DrawCell(withTitle: AlternateHomeTools.getNSLocalized("role_detail_org_unit_title", in: "Vector"), andSubtitle: role?.orgName)
            default:
                break
            }
            return cell
        case SectionType.PRACTITIONER_ROLE.rawValue:
            if !practitionersLoaded {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingDataTableViewCell") as? LoadingDataTableViewCell else { return UITableViewCell() }
                return cell
            }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SectionType.PRACTITIONER_ROLE.cellIdentifier) as? PractitionerTableViewCell else { return UITableViewCell() }
            cell.setUser(practitioners[indexPath.row])
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == SectionType.PRACTITIONER_ROLE.rawValue {
            return AlternateHomeTools.getNSLocalized("role_detail_practitioner_in_role", in: "Vector")
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerFooterView = view as? UITableViewHeaderFooterView else { return }
        let background = UIView()
        background.backgroundColor = ThemeService.shared().theme.tintBackgroundColor
        headerFooterView.backgroundView = background
        headerFooterView.textLabel?.textColor = ThemeService.shared().theme.textPrimaryColor
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == SectionType.PRACTITIONER_ROLE.rawValue {
            let vc = PeopleDetailViewController()
            guard let cell = self.tableView(tableView, cellForRowAt: indexPath) as? PractitionerTableViewCell else { return }
            guard let person = cell.user else { return }
            vc.setPerson(person: person)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension RoleDetailViewController: DetailFavouriteTableCellDelegate {
    var IsFavourite: Bool {
        get {
            role?.Favourite == true
        }
        set (v) {
            role?.Favourite = v
        }
    }
}
