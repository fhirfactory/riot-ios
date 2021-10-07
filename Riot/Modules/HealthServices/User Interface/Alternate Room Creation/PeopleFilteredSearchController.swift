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

//TODO: Switch this to use the directory services directory

class PeopleFilteredSearchController: SelectableFilteredSearchController<ActPeopleModel> {
    var currentSearch: MXHTTPOperation?
    override func registerReuseIdentifierForTableView(_ tableView: UITableView) {
        tableView.register(UINib(nibName: "PeopleTableViewCell", bundle: nil), forCellReuseIdentifier: "PeopleTableViewCell")
    }
    override func paginate(page: Int, pageSize: Int, filter: String?, favourites: Bool, addPage: @escaping ([ActPeopleModel]) -> Void) {
        Services.PractitionerService().SearchResources(query: filter, page: page, pageSize: pageSize) { practitioners, count in
            addPage(practitioners.map({ practitioner in
                ActPeopleModel(innerPractitioner: practitioner)
            }))
        } andFailureCallback: { err in
            
        }

    }
    override func getUnderlyingValue(_ tableViewCell: UITableViewCell) -> ActPeopleModel? {
        guard let actualCell = tableViewCell as? PeopleTableViewCell else { return nil }
        return actualCell.actPerson
    }
    override func getTableviewCell(_ tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleTableViewCell") as? PeopleTableViewCell else { return UITableViewCell() }
        let person = items[indexPath.row]
        cell.bind(data: person, index: indexPath.row)
        return cell
    }
    override func getIndexPathFor(Item theItem: ActPeopleModel) -> IndexPath? {
        if let idx = items.firstIndex(of: theItem) {
            return IndexPath(row: idx, section: 0)
        }
        return nil
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if items.count == 1 {
            return "1 " + AlternateHomeTools.getNSLocalized("person_single", in: "Vector")
        } else if items.count > 1 {
            return String(items.count) + " " + AlternateHomeTools.getNSLocalized("person_plural", in: "Vector")
        }
        return nil
    }
}
