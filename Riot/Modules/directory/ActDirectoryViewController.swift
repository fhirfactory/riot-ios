//
//  DirectoryViewController.swift
//  Riot
//
//  Created by Naurin Afrin on 31/7/20.
//  Copyright © 2020 matrix.org. All rights reserved.
//

import UIKit
import Material

class ActDirectoryViewController: TabsController {
    
    open override func prepare() {
        viewControllers =  [ActRoleViewController(), ActPeopleViewController()]
        super.prepare()
        tabBar.setLineColor(Color.orange.base, for: .selected) // or tabBar.lineColor = Color.orange.base
        tabBar.setTabItemsColor(Color.grey.base, for: .normal)
        tabBar.setTabItemsColor(Color.purple.base, for: .selected)
        tabBar.setTabItemsColor(Color.green.base, for: .highlighted)
        
        tabBar.setTabItemsColor(Color.blue.base, for: .selected)
        tabBarAlignment = .top
        tabBar.tabBarStyle = .auto
        tabBar.dividerColor = nil
        
        AppDelegate.the()?.masterTabBarController.navigationItem.title = NSLocalizedString("directory_title", tableName: "Vector", comment: "")
        AppDelegate.the().masterTabBarController.tabBar.tintColor = ThemeService.shared().theme.tintColor
    }
}
