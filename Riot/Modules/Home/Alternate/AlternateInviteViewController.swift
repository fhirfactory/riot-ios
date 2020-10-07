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
class AlternateInviteViewController: RecentsViewController {
    
    //this is okay, because viewWillAppear will fire before anything else that relies on the Home Data Source
    var HomeDataSource: AlternateHomeDataSource!
    
    static override func nib() -> UINib! {
        UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
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
        HomeDataSource.setViewMode(m: HomeViewMode.Favourites)
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
    }
    
}
