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
        
        tabBar.tabItems.first?.setTabItemColor(Color.blue.base, for: .selected)
        //    let color = tabBar.tabItems.first?.getTabItemColor(for: .selected)
        
        tabBarAlignment = .top
        //    tabBar.tabBarStyle = .auto
        //    tabBar.dividerColor = nil
        //    tabBar.lineHeight = 5.0
        //    tabBar.lineAlignment = .bottom
        //    tabBar.backgroundColor = Color.blue.darken2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
