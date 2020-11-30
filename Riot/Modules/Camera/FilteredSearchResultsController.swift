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

class FilteredSearchResultsController<T>: SelectableFilteredSearchController<T> where T: Equatable {
    var QueryList: [T] = []
    var connectedService: AsyncQueryableService<T>!
    var reuseIdentifier: String!
    func initializeService(With service: AsyncQueryableService<T>, AndReuseIdentifier identifier: String) {
        connectedService = service
        reuseIdentifier = identifier
    }
    
    init(withSelectionChangeHandler changeHandler: @escaping ((T, Bool) -> Void), andScrollHandler scrollHandler: @escaping (() -> Void), andReuseIdentifier reuseID: String, andConnectedService connectedService: AsyncQueryableService<T>) {
        super.init(withSelectionChangeHandler: changeHandler, andScrollHandler: scrollHandler)
        initializeService(With: connectedService, AndReuseIdentifier: reuseID)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func registerReuseIdentifierForTableView(_ tableView: UITableView) {
        tableView.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellReuseIdentifier: reuseIdentifier)
    }
    override func applyFilter(_ filter: String) {
        connectedService.Query(queryDetails: filter, success: { (returnedList) in
            QueryList = returnedList
            self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }, failure: {
            //presumably an internet failure, in prod
        })
    }
    override func viewDidAppear(_ animated: Bool) {
        applyFilter("")
    }
    override func getUnderlyingValue(_ tableViewCell: UITableViewCell) -> T? {
        guard let actualCell = tableViewCell as? QueryTableViewCell<T> else { return nil }
        return actualCell.CurrentValue
    }
    override func getTableviewCell(_ tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? QueryTableViewCell<T> else { return UITableViewCell() }
        let Result = QueryList[indexPath.row]
        cell.RenderWith(Object: Result)
        return cell
    }
    override func getIndexPathFor(Item theItem: T) -> IndexPath? {
        if let idx = QueryList.firstIndex(of: theItem) {
            return IndexPath(row: idx, section: 0)
        }
        return nil
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return QueryList.count
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if QueryList.count == 1 {
            return "1 " + AlternateHomeTools.getNSLocalized("person_single", in: "Vector")
        } else if QueryList.count > 1 {
            return String(QueryList.count) + " " + AlternateHomeTools.getNSLocalized("person_plural", in: "Vector")
        }
        return nil
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
}
