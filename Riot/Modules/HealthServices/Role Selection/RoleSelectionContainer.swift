// 
// Copyright 2020 New Vector Ltd
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation

enum TableViews: Int {
    case selectedRoles = 1
    case roleSearch = 2
}

class RoleSelectionContainer: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, SelectableRoleCellDelegate, RoleCellDelegate {
    
    func expandButtonClick(cell: RoleTableViewCell, index: Int) {
        guard let sendingTableView = cell.superview as? UITableView else { return }
        switch sendingTableView.tag {
        case TableViews.selectedRoles.rawValue:
            UIView.animate(withDuration: 0.3) {
                cell.isDisplayed = !cell.isDisplayed
                cell.layoutIfNeeded()
                self.selectedRoles[index].isExpanded = !self.selectedRoles[index].isExpanded
            } completion: { (animated) in
                self.recalculateHeightOfSelectedRolesTableView()
            }
            self.recalculateHeightOfSelectedRolesTableView()
            SelectedRolesTableview.beginUpdates()
            SelectedRolesTableview.endUpdates()
            
        case TableViews.roleSearch.rawValue:
            UIView.animate(withDuration: 0.3) {
                cell.isDisplayed = !cell.isDisplayed
                cell.layoutIfNeeded()
                self.queryRoles[index].isExpanded = !self.queryRoles[index].isExpanded
            } completion: { (animated) in
                self.recalculateHeightOfSelectedRolesTableView()
            }
            self.recalculateHeightOfSelectedRolesTableView()
            RolesListTableView.beginUpdates()
            RolesListTableView.endUpdates()
            
        default:
            break
        }
            
    }
    
    func FavouritesUpdated(favourited: Bool) {
        return
    }
    
    @IBOutlet weak var RolesSelectedLabel: UILabel!
    @IBOutlet weak var SelectedRolesTableview: UITableView!
    @IBOutlet weak var RolesListTableView: UITableView!
    @IBOutlet weak var SelectedRolesTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var RoleQuerySearchBar: UISearchBar!
    
    override func viewDidLoad() {
        SelectedRolesTableview.tag = TableViews.selectedRoles.rawValue
        RolesListTableView.tag = TableViews.roleSearch.rawValue
        SelectedRolesTableview.register(UINib(nibName: "RoleTableViewCell", bundle: nil), forCellReuseIdentifier: "RoleTableViewCell")
        RolesListTableView.register(UINib(nibName: "RoleTableViewCell", bundle: nil), forCellReuseIdentifier: "RoleTableViewCell")
        
        Services.RoleService().Query(queryDetails: "", success: queryCallBack(roles:)) {
            
        }

    }
    
    func recalculateHeightOfSelectedRolesTableView() {
        var height: CGFloat = 0
        for i in 0..<tableView(SelectedRolesTableview, numberOfRowsInSection: 0) {
            guard let cell = tableView(SelectedRolesTableview, cellForRowAt: IndexPath(item: i, section: 0)) as? RoleTableViewCell else { continue }
            height += cell.frame.height - (!cell.isDisplayed ? cell.detailedView.frame.height : 0)
        }
        UIView.animate(withDuration: 0.3) {
            self.SelectedRolesTableViewHeight.constant = height
            self.view.layoutIfNeeded()
        }
        
    }
    
    func selectionChanged(cell: RoleTableViewCell, index: Int) {
        if let roleselectable = cell.roleSelectable, roleselectable.isSelected {
            selectedRoles.append(roleselectable)
            _queryRoles = []
            SelectedRolesTableview.reloadSections(IndexSet(integer: 0), with: .automatic)
            RolesListTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            recalculateHeightOfSelectedRolesTableView()
        } else if let roleselectable = cell.roleSelectable, !roleselectable.isSelected {
            selectedRoles.remove(at: index)
            _queryRoles = []
            SelectedRolesTableview.reloadSections(IndexSet(integer: 0), with: .automatic)
            RolesListTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            recalculateHeightOfSelectedRolesTableView()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView.tag {
        case TableViews.selectedRoles.rawValue:
            return selectedRoles.count
        case TableViews.roleSearch.rawValue:
            return queryRoles.count
        default:
            break
        }
        return 0
    }
    
    
    func queryCallBack(roles: [Role]) {
        queryRoles = roles.map({ (r) in
            let role = RoleSelectable(innerRole: r, isExpanded: false)
            role.isSelected = selectedRoles.contains(role)
            return role
        })
    }
    
    private var _queryResults: [RoleSelectable] = []
    private var _queryRoles: [RoleSelectable] = []
    var queryRoles: [RoleSelectable] {
        get {
            if _queryRoles.count == 0 && _queryResults.count > 0 {
                _queryRoles = _queryResults.filter({ (itm) in
                    !selectedRoles.contains(itm)
                })
            }
            return _queryRoles
        }
        set (value) {
            _queryResults = value
            RolesListTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
    }
    
    var selectedRoles: [RoleSelectable] = []
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView.tag {
        case TableViews.selectedRoles.rawValue:
            let role = selectedRoles[indexPath.row]
            guard let roleCell = tableView.dequeueReusableCell(withIdentifier: "RoleTableViewCell", for: indexPath) as? RoleTableViewCell else { return UITableViewCell() }
            roleCell.bindModel(role: role, index: indexPath.row)
            roleCell.selectableDelegate = self
            roleCell.delegate = self
            return roleCell
        case TableViews.roleSearch.rawValue:
            let role = queryRoles[indexPath.row]
            guard let roleCell = tableView.dequeueReusableCell(withIdentifier: "RoleTableViewCell", for: indexPath) as? RoleTableViewCell else { return UITableViewCell() }
            roleCell.bindModel(role: role, index: indexPath.row)
            roleCell.selectableDelegate = self
            roleCell.delegate = self
            return roleCell
        default:
            break
        }
        return UITableViewCell()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.tag == TableViews.roleSearch.rawValue {
            RoleQuerySearchBar.resignFirstResponder()
        }
    }
}
