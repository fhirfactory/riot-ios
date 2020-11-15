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

class PatientSearchViewController: SelectableFilteredSearchController<PatientModel> {
    let patientList = [PatientModel(Name: "John Somebody", URN: "123456789", DoB: Date()), PatientModel(Name: "John The Nobody", URN: "987654321", DoB: Date()), PatientModel(Name: "Jill Bejonassie", URN: "234987234", DoB: Date())]
    override func registerReuseIdentifierForTableView(_ tableView: UITableView) {
        tableView.register(UINib(nibName: "PatientViewCell", bundle: nil), forCellReuseIdentifier: "PatientViewCell")
    }
    override func applyFilter(_ filter: String) {
        
    }
    override func getUnderlyingValue(_ tableViewCell: UITableViewCell) -> PatientModel? {
        guard let actualCell = tableViewCell as? PatientViewCell else { return nil }
        return actualCell.CurrentPatient
    }
    override func getTableviewCell(_ tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PatientViewCell") as? PatientViewCell else { return UITableViewCell() }
        let person = patientList[indexPath.row]
        cell.RenderWith(Patient: person)
        return cell
    }
    override func getIndexPathFor(Item theItem: PatientModel) -> IndexPath? {
        if let idx = patientList.firstIndex(of: theItem) {
            return IndexPath(row: idx, section: 0)
        }
        return nil
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patientList.count
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if patientList.count == 1 {
            return "1 " + AlternateHomeTools.getNSLocalized("person_single", in: "Vector")
        } else if patientList.count > 1 {
            return String(patientList.count) + " " + AlternateHomeTools.getNSLocalized("person_plural", in: "Vector")
        }
        return nil
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
}
