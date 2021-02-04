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
class ServiceDetailViewController: UITableViewController, DetailFavouriteTableCellDelegate {
    var IsFavourite: Bool {
        get {
            service.Favourite
        }
        set(v) {
            service.Favourite = v
        }
    }
    
    enum Rows: Int, CaseIterable {
        case Favourite = 0
        case Phone = 1
        case Location = 2
        var Identifier: String {
            switch self {
            case .Favourite:
                return "DetailFavouriteTableViewCell"
            case .Phone:
                return "PhoneTableViewCell"
            case .Location:
                return "ServiceLocationTableViewCell"
            }
        }
    }
    var service: ServiceModel!
    func setService(toService: ServiceModel) {
        service = toService
        navigationItem.title = toService.Name
    }
    override func viewDidLoad() {
        tableView.register(UINib(nibName: Rows.Favourite.Identifier, bundle: nil), forCellReuseIdentifier: Rows.Favourite.Identifier)
        tableView.register(UINib(nibName: Rows.Phone.Identifier, bundle: nil), forCellReuseIdentifier: Rows.Phone.Identifier)
        tableView.register(UINib(nibName: Rows.Location.Identifier, bundle: nil), forCellReuseIdentifier: Rows.Location.Identifier)
        tableView.separatorStyle = .none
        ThemeService.shared().theme.recursiveApply(on: self.view)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        service == nil ? 0 : Rows.allCases.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case Rows.Favourite.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Rows.Favourite.Identifier) as? DetailFavouriteTableViewCell else { return UITableViewCell() }
            cell.FavouritesDelegate = self
            cell.itemTypeString = AlternateHomeTools.getNSLocalized("service_title", in: "Vector")
            cell.Render()
            return cell
        case Rows.Phone.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Rows.Phone.Identifier) as? PhoneTableViewCell else { return UITableViewCell() }
            cell.setNumber(number: service.Phone)
            return cell
        case Rows.Location.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Rows.Location.Identifier) as? ServiceLocationTableViewCell else { return UITableViewCell() }
            cell.SetService(toService: service)
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
}
