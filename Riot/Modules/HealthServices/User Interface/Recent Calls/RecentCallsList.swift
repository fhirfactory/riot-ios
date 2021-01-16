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
class RecentCallsList: UITableViewController {
    override func viewDidLoad() {
        tableView.register(UINib(nibName: "RecentCallItem", bundle: nil), forCellReuseIdentifier: "RecentCallItem")
        ThemeService.shared().theme.recursiveApply(on: self.view)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecentCallItem", for: indexPath) as? RecentCallItem else { return UITableViewCell() }
        cell.render(phoneCall: Call(asOutgoingToExternalPhoneNumber: "0412345678", withDateTime: Date(), andLength: TimeInterval(200)))
        return cell
    }
}
