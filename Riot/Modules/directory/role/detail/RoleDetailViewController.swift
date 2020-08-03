//
//  RoleDetailViewController.swift
//  Riot
//
//  Created by Naurin Afrin on 3/8/20.
//  Copyright © 2020 matrix.org. All rights reserved.
//

import UIKit

enum SectionType {
    case ROLE_PROFILE
    case ROLE_TITLE
    case SPECIALITY
    case LOCATION
    case TEAM
    case ORGANISATION_UNIT
    case PRACTITIONER_ROLE
}

class RoleDetailViewController: UIViewController {
    var role:RoleModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}
