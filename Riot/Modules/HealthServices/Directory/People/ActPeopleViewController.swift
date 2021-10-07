//
//  ActPeopleViewController.swift
//  Riot
//
//  Created by Naurin Afrin on 31/7/20.
//  Copyright © 2020 matrix.org. All rights reserved.
//

import UIKit

class ActPeopleViewController: SimpleSelectableFilteredSearchController<PeopleTableViewCell, ActPeopleModel> {
    override func selectedItem(item: ActPeopleModel) {
        let vc = PeopleDetailViewController()
        vc.setPerson(person: item)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func paginate(page: Int, pageSize: Int, filter: String?, favourites: Bool, addPage: @escaping ([ActPeopleModel]) -> Void) {
        Services.PractitionerService().SearchResources(query: filter, page: page, pageSize: pageSize) { vals, count in
            addPage(vals.map({ person in
                ActPeopleModel(innerPractitioner: person)
            }))
        } andFailureCallback: { err in

        }
    }
    
    init() {
        super.init(nibName: "GenericDirectoryController", bundle: nil)
        mode = .Directory
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
