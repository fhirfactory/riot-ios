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

enum HomeViewMode{
    case Chats
    case Favourites
    case LowPriority
}

class AlternateHomeViewController: RecentsViewController {
    
    //this is okay, because viewWillAppear will fire before anything else that relies on the Home Data Source
    var HomeDataSource : AlternateHomeDataSource!
    
    @IBOutlet weak var modeSelector : UISegmentedControl!
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
    
    override func viewWillAppear(_ animated: Bool) {
//        let source = RecentsDataSource()
//        source.setDelegate(self, andRecentsDataSourceMode: RecentsDataSourceMode.people)
        self.recentsTableView.tag = Int(RecentsDataSourceMode.home.rawValue)
//        (self.dataSource as! RecentsDataSource).setDelegate(self, andRecentsDataSourceMode: RecentsDataSourceMode.people)
        AppDelegate.theDelegate().masterTabBarController.navigationItem.title = AlternateHomeTools.getNSLocalized("title_home", in: "Vector")
        if let something = self.dataSource as? RecentsDataSource {
            something.setDelegate(self, andRecentsDataSourceMode: RecentsDataSourceMode.home)
        }
        HomeDataSource = AlternateHomeDataSource(matrixSession: mxSessions.first as? MXSession)
        HomeDataSource.setDelegate(self, andRecentsDataSourceMode: RecentsDataSourceMode.home)
        super.setValue(HomeDataSource, forKey: "dataSource")
        super.viewWillAppear(animated)
        recentsTableView.dataSource = HomeDataSource
        HomeDataSource.setViewMode(m: HomeViewMode.Chats)
        modeSelector.removeAllSegments()
        modeSelector.insertSegment(withTitle: "Chats", at: 0, animated: false)
        modeSelector.insertSegment(withTitle: "Favourites", at: 1, animated: false)
        modeSelector.insertSegment(withTitle: "Low Priority", at: 2, animated: false)
        modeSelector.selectedSegmentIndex = 0
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return super.tableView(tableView, trailingSwipeActionsConfigurationForRowAt: HomeDataSource.getIndexPathInUnderlying(indexPathFor: indexPath))
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.refreshRecentsTable()
    }
    
}
