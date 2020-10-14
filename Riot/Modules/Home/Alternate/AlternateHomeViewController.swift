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
import UIKit

enum HomeViewMode {
    case Chats
    case Favourites
    case LowPriority
    case Invites
}

class AlternateHomeViewController: RecentsViewController {
    
    //this is okay, because viewWillAppear will fire before anything else that relies on the Home Data Source
    var HomeDataSource: AlternateHomeDataSource!
    
    @IBOutlet weak var modeSelector: UISegmentedControl!
    @IBAction private func SelectionChanged() {
        switch modeSelector.selectedSegmentIndex {
        case 0:
            self.HomeDataSource.setViewMode(m: HomeViewMode.Chats)
            self.recentsTableView.reloadData()
        case 1:
            self.HomeDataSource.setViewMode(m: HomeViewMode.Favourites)
            self.recentsTableView.reloadData()
        case 2:
            self.HomeDataSource.setViewMode(m: HomeViewMode.LowPriority)
            self.recentsTableView.reloadData()
        default:
            break
        }
    }
    
    static override func nib() -> UINib! {
        UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in
            self.drawBadges()
        }
    }
    
    func drawBadgeFor(segment: Int, badgeValue: UInt, controller: UISegmentedControl) -> UIView? {
        if badgeValue == 0 {
            return nil
        }
        let window = UIApplication.shared.keyWindow
        let safeAreaOffset: CGFloat = (UIDevice.current.orientation == .landscapeLeft ? window?.safeAreaInsets.left : UIDevice.current.orientation == .landscapeRight ? window?.safeAreaInsets.right : nil) ?? 0
        let badgeheight: CGFloat = 20.0
        let wSegment = controller.frame.width / CGFloat(controller.numberOfSegments)
        let baseXPosition = wSegment * CGFloat((segment + 1)) + controller.frame.minX
        let baseXPos2 = (controller.superview?.frame.minX ?? 0.0) + badgeheight
        let badge = UIView(frame: CGRect(x: baseXPosition + baseXPos2, y: controller.frame.minY, width: badgeheight, height: badgeheight))
        badge.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        badge.layer.cornerRadius = badge.frame.height / 2
        let badgeValueLabel = UILabel()
        badgeValueLabel.text = String(badgeValue)
        badgeValueLabel.textAlignment = .center
        badgeValueLabel.sizeToFit()
        badge.addSubview(badgeValueLabel)
        let badgeWidth = max(badge.frame.width, badgeValueLabel.frame.width + badge.frame.width / 2)
        badgeValueLabel.frame = CGRect(x: 0, y: badgeValueLabel.frame.minY, width: badgeWidth, height: badgeValueLabel.frame.height)
        badge.frame = CGRect(x: safeAreaOffset + badge.frame.minX - badgeWidth / 2, y: badge.frame.minY, width: badgeWidth, height: badge.frame.height)
        view.addSubview(badge)
        return badge
    }
    
    var badges: [UIView] = []
    
    func drawBadges() {
        if HomeDataSource == nil {
            return
        }
        for badge in badges {
            badge.removeFromSuperview()
        }
        badges = []
        if let b = drawBadgeFor(segment: 1, badgeValue: HomeDataSource.getBadgeValueForSectionMode(section: .Favourites), controller: modeSelector) {
            badges.append(b)
        }
        if let b = drawBadgeFor(segment: 0, badgeValue: HomeDataSource.getBadgeValueForSectionMode(section: .Chats), controller: modeSelector) {
            badges.append(b)
        }
        if let b = drawBadgeFor(segment: 2, badgeValue: HomeDataSource.getBadgeValueForSectionMode(section: .LowPriority), controller: modeSelector) {
            badges.append(b)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.recentsTableView.tag = Int(RecentsDataSourceMode.home.rawValue)
        AppDelegate.theDelegate().masterTabBarController.navigationItem.title = AlternateHomeTools.getNSLocalized("title_home", in: "Vector")
        if let something = self.dataSource as? RecentsDataSource {
            something.setDelegate(self, andRecentsDataSourceMode: RecentsDataSourceMode.home)
        }
        if mxSessions.first == nil {
            return
        }
        HomeDataSource = AlternateHomeDataSource(matrixSession: mxSessions.first as? MXSession)
        HomeDataSource.setDelegate(self, andRecentsDataSourceMode: RecentsDataSourceMode.home)
        super.setValue(HomeDataSource, forKey: "dataSource")
        super.viewWillAppear(animated)
        recentsTableView.dataSource = HomeDataSource
        HomeDataSource.setViewMode(m: HomeViewMode.Chats)
        modeSelector.removeAllSegments()
        modeSelector.insertSegment(withTitle: AlternateHomeTools.getNSLocalized("room_recents_chats_section", in: "Vector"), at: 0, animated: false)
        modeSelector.insertSegment(withTitle: AlternateHomeTools.getNSLocalized("room_recents_favourites_section", in: "Vector"), at: 1, animated: false)
        modeSelector.insertSegment(withTitle: AlternateHomeTools.getNSLocalized("room_recents_low_priority_section", in: "Vector"), at: 2, animated: false)
        modeSelector.selectedSegmentIndex = 0
        
        drawBadges()
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipeActions = super.getContextualActions(for: tableView, at: HomeDataSource.getIndexPathInUnderlying(indexPathFor: indexPath))
        if var actions = swipeActions {
            actions.remove(at: actions.count - 1)
            return UISwipeActionsConfiguration(actions: actions)
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.refreshRecentsTable()
    }
    
    override func dataSource(_ dataSource: MXKDataSource!, didCellChange changes: Any!) {
        super.dataSource(dataSource, didCellChange: changes)
        drawBadges()
    }
    
}
