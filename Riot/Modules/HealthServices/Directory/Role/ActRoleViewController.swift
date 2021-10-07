//
//  ActRoleViewController.swift
//  Riot
//
//  Created by Naurin Afrin on 31/7/20.
//  Copyright © 2020 matrix.org. All rights reserved.
//

import UIKit


//private enum SectionType: Int, CaseIterable {
//    case FILTER = 0
//    case ROLE_CELL = 1
//    
//    var cellIdentifier: String {
//        switch self {
//        case .FILTER:
//            return "RoleFilterTableViewCell"
//        case .ROLE_CELL:
//            return "RoleTableViewCell"
//        }
//    }
//}

class ActRoleViewController: SimpleSelectableFilteredSearchController<RoleTableViewCell, RoleModel> {
    override func selectedItem(item: RoleModel) {
        let vc = RoleDetailViewController()
        vc.role = item
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func paginate(page: Int, pageSize: Int, filter: String?, favourites: Bool, addPage: @escaping ([RoleModel]) -> Void) {
        Services.PractitionerRoleService().SearchResources(query: filter, page: page, pageSize: pageSize) { vals, count in
            addPage(vals.map({ role in
                RoleModel(innerRole: role, isExpanded: false)
            }))
        } andFailureCallback: { err in
            
        }
    }
    
    override func bindContentToCell(cell: RoleTableViewCell, data: RoleModel, index: Int) {
        super.bindContentToCell(cell: cell, data: data, index: index)
        cell.delegate = self
    }
    
    init() {
        super.init(nibName: "GenericDirectoryController", bundle: nil)
        mode = .Directory
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension ActRoleViewController: RoleCellDelegate {
    func expandButtonClick(cell: RoleTableViewCell, index: Int) {
        UIView.animate(withDuration: 0.3) {
            cell.isDisplayed = !cell.isDisplayed
            cell.role?.Favourite = !(cell.role?.Favourite ?? true)
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func FavouritesUpdated(favourited: Bool) {
        
    }
}
