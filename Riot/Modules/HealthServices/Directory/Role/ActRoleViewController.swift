//
//  ActRoleViewController.swift
//  Riot
//
//  Created by Naurin Afrin on 31/7/20.
//  Copyright © 2020 matrix.org. All rights reserved.
//

import UIKit


/*private enum SectionType: Int, CaseIterable {
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
}*/

class ActRoleViewController: UIViewController {
    @IBOutlet weak var rolesTableView: UITableView!
    @IBOutlet weak var FavouritesButton: UIButton!
    @IBOutlet weak var SearchBar: UISearchBar!
    
    
    // TODO:- This needs to be replaced with appropriate code once the backend is available and can provide role information to the app
    
    var roles = [
        RoleModel(innerRole: Role(name: "ED Acute SRMO", longname: "Senior Resident Medical Officer", id: "na", description: "Emergency Department Acute Senior Resident Medical Officer", designation: "Senior Resident Medical Officer", category: "Emergency", location: "CH {Canberra Hospital}", orgunit: "ED {Emergency Department}"), isExpanded: false),
        RoleModel(innerRole: Role(name: "ED Acute RMO", longname: "Resident Medical Officer", id: "na", description: "Emergency Department Acute Resident Medical Officer", designation: "Resident Medical Officer", category: "Emergency", location: "CH {Canberra Hospital}", orgunit: "ED {Emergency Department}"), isExpanded: false),
        RoleModel(innerRole: Role(name: "ED Acute Intern", longname: "Intern", id: "na", description: "Emergency Department Acute Intern", designation: "Intern", category: "Emergency", location: "CH {Canberra Hospital}", orgunit: "ED {Emergency Department}"), isExpanded: false)
    ]
    
    var favourites: [RoleModel] {
        get {
            return roles.filter { (r) -> Bool in
                r.Favourite
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabItem.title = AlternateHomeTools.getNSLocalized("role_title", in: "Vector")
        self.view.accessibilityIdentifier = "RoleVCView"
        ThemeService.shared().theme.recursiveApply(on: self.view)
        rolesTableView.backgroundColor = ThemeService.shared().theme.backgroundColor
        //self.recentsTableView.accessibilityIdentifier = "RoleVCTableView"
        //self.addPlusButton()
        //enableSearchBar = false
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rolesTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
    
    var showingFavourites: Bool = false
    @IBAction func FavouritesToggled(_ sender: Any) {
        showingFavourites = !showingFavourites
        if #available(iOS 13.0, *) {
            FavouritesButton.setImage(UIImage(systemName: (showingFavourites ? "star.fill" : "star")), for: .normal)
        } else {
            // Fallback on earlier versions
        }
        rolesTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if SearchBar.isFirstResponder {
            SearchBar.resignFirstResponder()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if SearchBar.isFirstResponder {
            SearchBar.resignFirstResponder()
        }
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
        //rolesTableView.register(UINib(nibName: SectionType.FILTER.cellIdentifier, bundle: nil), forCellReuseIdentifier: SectionType.FILTER.cellIdentifier)
        rolesTableView.register(UINib(nibName: "RoleTableViewCell", bundle: nil), forCellReuseIdentifier: "RoleTableViewCell")
        rolesTableView.register(UINib(nibName: "NoFavouritesTableViewCell", bundle: nil), forCellReuseIdentifier: "NoFavouritesTableViewCell")
    }
}

// MARK: UITableViewDataSource
extension ActRoleViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showingFavourites {
            return max(1, favourites.count)
        }
        return roles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if showingFavourites && favourites.count == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoFavouritesTableViewCell") as? NoFavouritesTableViewCell else { return UITableViewCell() }
            cell.SetItem(to: AlternateHomeTools.getNSLocalized("roles_title", in: "Vector"))
            return cell
        }
        guard let roleCell = tableView.dequeueReusableCell(withIdentifier: "RoleTableViewCell", for: indexPath) as? RoleTableViewCell else { return UITableViewCell() }
        roleCell.delegate = self
        roleCell.bindModel(role: showingFavourites ? favourites[indexPath.row] : roles[indexPath.row], index: indexPath.row)
        return roleCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rolesTableView.deselectRow(at: indexPath, animated: true)
        let vc = RoleDetailViewController() //your view controller
        if showingFavourites && favourites.count > 0 {
            vc.role = favourites[indexPath.row]
        } else {
            vc.role = roles[indexPath.row]
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
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

extension ActRoleViewController: FavouriteActionReceiverDelegate {
    func favouritesUpdated(favourited: Bool) {
        if showingFavourites && !favourited {
            rolesTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
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

extension ActRoleViewController {
    override func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
