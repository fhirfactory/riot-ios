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
    
    func redrawBadges() {
        if homeDataSource != nil {
            sections.setBadge(BadgeData(colour: UIColor.red, andBadgeNumber: Int(homeDataSource.missedChatCount), andShouldDisplay: homeDataSource.missedChatCount > 0), forLocation: 0)
            sections.setBadge(BadgeData(colour: UIColor.red, andBadgeNumber: Int(homeDataSource.missedFavouriteCount), andShouldDisplay: homeDataSource.missedFavouriteCount > 0), forLocation: 1)
            sections.setBadge(BadgeData(colour: UIColor.red, andBadgeNumber: Int(homeDataSource.missedLowPriorityCount), andShouldDisplay: homeDataSource.missedLowPriorityCount > 0), forLocation: 2)
            sections.drawBadges()
        }
    }
    
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
            redrawBadges()
        }
    }
    
    @objc func AddRoomClicked(){
        let menu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        menu.addAction(UIAlertAction(title: AlternateHomeTools.getNSLocalized("room_recents_start_chat_with", in: "Vector"), style: .default, handler: nil)) //create 1:1 chat
        menu.addAction(UIAlertAction(title: AlternateHomeTools.getNSLocalized("room_recents_create_empty_room", in: "Vector"), style: .default, handler: {_ in
            let newvc = AlternateRoomCreationFlowAddMembersController()
            //self.present(newvc, animated: true, completion: nil)
            self.navigationController?.show(newvc, sender: self)
        })) //create group chat
        menu.addAction(UIAlertAction(title: AlternateHomeTools.getNSLocalized("room_recents_join_room", in: "Vector"), style: .default, handler: nil)) //join a chat
        
        menu.addAction(UIAlertAction(title: AlternateHomeTools.getNSLocalized("cancel", in: "Vector"), style: .cancel, handler: nil))
        self.present(menu, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let session = AppDelegate.theDelegate().mxSessions.first as? MXSession else { return }
        
        if homeDataSource == nil {
            homeDataSource = AlternateHomeDataSource(matrixSession: session)
            homeDataSource.countsUpdated = {
                self.redrawSections()
            }
        }
        
        let chatsContainer = HomeTabViewController()
        let favouritesContainer = HomeTabViewController()
        let lowPriorityContainer = HomeTabViewController()
        homeDataSource.setDelegate(chatsContainer, andRecentsDataSourceMode: .home)
        
        
        chatsContainer.HomeDataSource = homeDataSource
        chatsContainer.addMatrixSession(session)
        
        favouritesContainer.Mode = .Favourites
        favouritesContainer.HomeDataSource = AlternateHomeDataSource(matrixSession: session)
        favouritesContainer.addMatrixSession(session)
        
        lowPriorityContainer.Mode = .LowPriority
        lowPriorityContainer.HomeDataSource = AlternateHomeDataSource(matrixSession: session)
        lowPriorityContainer.addMatrixSession(session)
        
        sections.initWithTitles(["Chats", "Favourites", "Low Priority"], viewControllers: [chatsContainer, favouritesContainer, lowPriorityContainer], defaultSelected: 0)
        redrawSections()
        
        sections.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        view.addSubview(sections.view)
        
        let createRoomButton = UIButton(type: .custom)
        createRoomButton.setImage(UIImage(asset: ImageAsset(name: "plus_floating_action")), for: .normal)
        createRoomButton.translatesAutoresizingMaskIntoConstraints = false
        
        createRoomButton.addTarget(self, action: #selector(AddRoomClicked), for: .touchUpInside)
        view.addSubview(createRoomButton)
        
        NSLayoutConstraint.activate(
            [
                NSLayoutConstraint(item: createRoomButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: -10),
                NSLayoutConstraint(item: createRoomButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: -10)
            ]
        )
        createRoomButton.layoutIfNeeded()
    }
    
    @objc func displayList(_ l: RecentsDataSource) {
        //just to save us from crashing
    }
    
    @objc func dataSource(_ dataSource: MXKDataSource!, didCellChange changes: Any!) {
        redrawSections()
    }
}
