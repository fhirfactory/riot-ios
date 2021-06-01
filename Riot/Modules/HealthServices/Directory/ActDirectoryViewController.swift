//
//  DirectoryViewController.swift
//  Riot
//
//  Created by Naurin Afrin on 31/7/20.
//  Copyright © 2020 matrix.org. All rights reserved.
//

import UIKit
import Material

@objc class ActDirectoryViewController: SegmentedViewController {
    
    override func viewDidLoad() {
        self.initWithTitles(
            [
                AlternateHomeTools.getNSLocalized("roles_title", in: "Vector") as Any,
                AlternateHomeTools.getNSLocalized("people_title", in: "Vector") as Any,
                AlternateHomeTools.getNSLocalized("services_title", in: "Vector") as Any
            ], viewControllers:
                [
                    ActRoleViewController(),
                    ActPeopleViewController(),
                    ActServicesViewController()
                ], defaultSelected: 0)
        super.viewDidLoad()
        AppDelegate.theDelegate().masterTabBarController.navigationItem.title = AlternateHomeTools.getNSLocalized("directory_title", in: "Vector")
    }
    
    @objc func displayList(_ l: RecentsDataSource) {
        //just to save us from crashing
    }
}
