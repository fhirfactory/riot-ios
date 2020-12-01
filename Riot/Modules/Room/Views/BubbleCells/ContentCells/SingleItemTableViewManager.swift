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

class SingleItemTableViewManager<T,U>: NSObject, UITableViewDelegate, UITableViewDataSource where T: QueryTableViewCell<U> {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        _items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as? T else { return UITableViewCell() }
        cell.RenderWith(Object: _items[indexPath.row])
        return cell
    }
    
    private let cellReuseIdentifier: String
    private var _items: [U] = []
    private var managedTableView: UITableView!
    var items: [U] {
        get {
            return _items
        }
        set {
            _items = newValue
            managedTableView.reloadData()
        }
    }
    func attachTo(tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: cellReuseIdentifier, bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        managedTableView = tableView
    }
    
    init(reuseIdentifier: String) {
        cellReuseIdentifier = reuseIdentifier
    }
    
    init(reuseIdentifier: String, tableView: UITableView) {
        cellReuseIdentifier = reuseIdentifier
        super.init()
        attachTo(tableView: tableView)
    }
}
