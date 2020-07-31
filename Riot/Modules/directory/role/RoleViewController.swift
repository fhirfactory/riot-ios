//
//  RoleViewController.swift
//  Riot
//
//  Created by Naurin Afrin on 29/7/20.
//  Copyright © 2020 matrix.org. All rights reserved.
//

import UIKit

struct RoleModel {
    var name: String
    var description: String
    var isExpanded: Bool
}

class RoleViewController: UIViewController {
        override func viewDidLoad() {
            super.viewDidLoad()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            AppDelegate.the()?.masterTabBarController.navigationItem.title = NSLocalizedString("title_people", tableName: "Vector", comment: "")
            AppDelegate.the().masterTabBarController.tabBar.tintColor = ThemeService.shared().theme.tintColor
        }
    }
