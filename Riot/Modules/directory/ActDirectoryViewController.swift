//
//  DirectoryViewController.swift
//  Riot
//
//  Created by Naurin Afrin on 31/7/20.
//  Copyright © 2020 matrix.org. All rights reserved.
//

import UIKit
import Material

class ActDirectoryViewController: UIViewController {
    let tabController = TabsController(viewControllers: [ActRoleViewController(), ActPeopleViewController()])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabController.tabBarAlignment = .top
        tabController.tabBar.lineAlignment = .bottom
        tabController.tabBar.dividerColor = nil
        tabController.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tabController.view)        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate.the()?.masterTabBarController.navigationItem.title = NSLocalizedString("directory_title", tableName: "Act", comment: "")
        AppDelegate.the().masterTabBarController.tabBar.tintColor = ThemeService.shared().theme.tintColor
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if #available(iOS 11.0, *) {
            let guide = self.view.safeAreaLayoutGuide
            tabController.view.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
            tabController.view.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
            tabController.view.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
            tabController.view.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
        }else{
            NSLayoutConstraint(item: tabController.view!, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: tabController.view!, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: tabController.view!, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
            tabController.view.heightAnchor.constraint(equalToConstant: 100).isActive = true
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
