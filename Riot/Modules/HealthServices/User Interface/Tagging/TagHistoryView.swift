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

class TagHistoryView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    static func nib() -> UINib! {
        UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
    
    override func viewDidLoad() {
        tableView.register(TagHistoryCell.self, forCellReuseIdentifier: "TagHistoryCell")
        TitleLabel.text = AlternateHomeTools.getNSLocalized("tag_history_title", in: "Vector")
    }
    
    @objc var tags: [TagData] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TagHistoryCell", for: indexPath) as? TagHistoryCell else { return UITableViewCell() }
        //We render the tags array in reverse order.
        cell.render(withTagData: tags[(tags.count-1)-indexPath.row])
        return cell
    }
}
