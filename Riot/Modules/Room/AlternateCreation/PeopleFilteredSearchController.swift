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

class PeopleFilteredSearchController : SelectableFilteredSearchController<ActPeople> {
    var currentSearch: MXHTTPOperation?
    var peopleList: [ActPeople] = []
    
    override func applyFilter(_ filter: String) {
        if currentSearch != nil {
            currentSearch?.cancel()
            currentSearch = nil
        }
        currentSearch = session.matrixRestClient.searchUsers(filter, limit: 50, success: {(users) in
            self.peopleList = []
            if let usersList: [MXUser] = users?.results {
                for p: MXUser in usersList {
                    if p.displayname != nil {
                        var actPerson = ActPeople(withBaseUser: p, officialName: p.displayname, jobTitle: "Worker", org: "At Org", businessUnit: "In Business Unit")
                        actPerson.emailAddress = "noname@gmail.com"
                        actPerson.phoneNumber = "0412345678"
                        self.peopleList.append(actPerson)
                    }
                }
            }
            self.tableView.reloadData()
        }, failure: {(error) in
            
        })
    }
    override func getUnderlyingValue(_ tableViewCell: UITableViewCell) -> ActPeople? {
        guard let actualCell = tableViewCell as? PeopleTableViewCell else { return nil }
        return actualCell.actPeople
    }
    override func getTableviewCell(_ tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleTableViewCell") as? PeopleTableViewCell else { return UITableViewCell() }
        let person = peopleList[indexPath.row]
        cell.setValue(actPeople: person, displayFavourites: false)
        return cell
    }
    override func getIndexPathFor(Item theItem: ActPeople) -> IndexPath? {
        if let idx = peopleList.firstIndex(of: theItem) {
            return IndexPath(row: idx, section: 0)
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peopleList.count
    }
}
