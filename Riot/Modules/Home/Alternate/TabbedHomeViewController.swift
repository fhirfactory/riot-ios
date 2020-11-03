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

class TabbedHomeViewController: UIViewController {
    
    let sections = SegmentedViewController()
    var homeDataSource: AlternateHomeDataSource!
    var favouritesWasVisible = false
    var lowPriorityWasVisible = false
    
    func redrawSections() {
        if homeDataSource != nil {
            let favourites = homeDataSource.favoritesSection > -1
            sections.visible[1] = favourites as NSNumber
            let lowPriority = homeDataSource.lowPrioritySection > -1
            sections.visible[2] = lowPriority as NSNumber
            if !(favouritesWasVisible == favourites && lowPriorityWasVisible == lowPriority) {
                sections.createSegmentedViews()
            }
            favouritesWasVisible = favourites
            lowPriorityWasVisible = lowPriority
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if homeDataSource == nil {
            homeDataSource = AlternateHomeDataSource(matrixSession: AppDelegate.theDelegate().mxSessions.first as? MXSession)
            homeDataSource.countsUpdated = {
                self.redrawSections()
            }
        }
        
        let chatsContainer = HomeTabViewController()
        let favouritesContainer = HomeTabViewController()
        let lowPriorityContainer = HomeTabViewController()
        homeDataSource.setDelegate(chatsContainer, andRecentsDataSourceMode: .home)
        
        
        chatsContainer.HomeDataSource = homeDataSource
        favouritesContainer.Mode = .Favourites
        favouritesContainer.HomeDataSource = AlternateHomeDataSource(matrixSession: AppDelegate.theDelegate().mxSessions.first as? MXSession)
        
        lowPriorityContainer.Mode = .LowPriority
        lowPriorityContainer.HomeDataSource = AlternateHomeDataSource(matrixSession: AppDelegate.theDelegate().mxSessions.first as? MXSession)
        
        sections.initWithTitles(["Chats", "Favourites", "Low Priority"], viewControllers: [chatsContainer, favouritesContainer, lowPriorityContainer], defaultSelected: 0)
        redrawSections()
        
        sections.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        view.addSubview(sections.view)
    }
    
    @objc func displayList(_ l: RecentsDataSource) {
        //just to save us from crashing
    }
    
    @objc func dataSource(_ dataSource: MXKDataSource!, didCellChange changes: Any!) {
        redrawSections()
    }
}
