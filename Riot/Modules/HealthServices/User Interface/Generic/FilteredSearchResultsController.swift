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

class FilteredSearchResultsController<Service: DataQueryService, T>: SelectableFilteredSearchController<T> where T: Equatable, T == Service.ReturnType {
    var connectedService: Service!
    var reuseIdentifier: String!
    func initializeService(With service: Service, AndReuseIdentifier identifier: String) {
        connectedService = service
        reuseIdentifier = identifier
    }
    
    var cellNibName: String!
    override func getNib() -> UINib {
        UINib(nibName: cellNibName, bundle: nil)
    }
    
    init(withSelectionChangeHandler changeHandler: @escaping ((T, Bool) -> Void),
         andScrollHandler scrollHandler: @escaping (() -> Void),
         andReuseIdentifier reuseID: String,
         andConnectedService connectedService: Service,
         nibName: String? = nil) {
        super.init(withSelectionChangeHandler: changeHandler, andScrollHandler: scrollHandler)
        cellNibName = reuseID
        initializeService(With: connectedService, AndReuseIdentifier: reuseID)
        if let name = nibName {
            cellNibName = name
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(nibName: String?, bundle: Bundle?) {
        super.init(nibName: nibName, bundle: bundle)
    }
    
    override func registerReuseIdentifierForTableView(_ tableView: UITableView) {
        tableView.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellReuseIdentifier: reuseIdentifier)
    }
    override func paginate(page: Int, pageSize: Int, filter: String?, favourites: Bool, addPage: @escaping ([T]) -> Void) {
        connectedService.SearchResources(query: filter, page: page, pageSize: pageSize) { (returnedList, count)  in
            addPage(returnedList)
        } andFailureCallback: { err in
            
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func getTableviewCell(_ tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? QueryTableViewCell<T> else { return UITableViewCell() }
        let Result = items[indexPath.row]
        cell.RenderWith(Object: Result)
        return cell
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if items.count == 1 {
//            return "1 " + AlternateHomeTools.getNSLocalized("person_single", in: "Vector")
//        } else if items.count > 1 {
//            return String(items.count) + " " + AlternateHomeTools.getNSLocalized("person_plural", in: "Vector")
//        }
//        return nil
//    }
}
