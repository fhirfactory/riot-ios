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

class ActServicesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var FavouritesButton: UIButton!
    override func viewDidLoad() {
        tableView.register(UINib(nibName: "ServiceTableViewCell", bundle: nil), forCellReuseIdentifier: "ServiceTableViewCell")
        tableView.register(UINib(nibName: "NoFavouritesTableViewCell", bundle: nil), forCellReuseIdentifier: "NoFavouritesTableViewCell")
    }
    var services: [Service] = [
        Service(withName: "Opthalmology Clinic", Phone: "0412345678", LocationFirstLine: "01.06.21.27", andLocationSecondLine: "Building 1 Level 2 Opthalmology Clinic"),
        Service(withName: "Opthalmology Clinic 2", Phone: "0412345678", LocationFirstLine: "01.06.21.27", andLocationSecondLine: "Building 1 Level 2 Opthalmology Clinic"),
        Service(withName: "Opthalmology Clinic 3", Phone: "0412345678", LocationFirstLine: "01.06.21.27", andLocationSecondLine: "Building 1 Level 2 Opthalmology Clinic")
    ]
    var favourites: [Service] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showingFavourites {
            return favourites.count == 0 ? 1 : favourites.count
        }
        return services.count
    }
    
    //TODO: Update to real data, when possible
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if showingFavourites && favourites.count == 0 {
            guard let errorCell = tableView.dequeueReusableCell(withIdentifier: "NoFavouritesTableViewCell", for: indexPath) as? NoFavouritesSetTableViewCell else { return UITableViewCell() }
            errorCell.SetItem(to: AlternateHomeTools.getNSLocalized("services_title", in: "Vector"))
            return errorCell
        }
        guard let serviceCell = tableView.dequeueReusableCell(withIdentifier: "ServiceTableViewCell", for: indexPath) as? ServiceTableViewCell else { return UITableViewCell() }
        serviceCell.setService(toService: services[indexPath.row])
        return serviceCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let serviceCell = self.tableView(tableView, cellForRowAt: indexPath) as? ServiceTableViewCell else { return }
        guard let service = serviceCell.Service else { return }
        let vc = ServiceDetailViewController()
        vc.setService(toService: service)
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    var showingFavourites: Bool = false
    @IBAction private func ToggleFavourites(_ sender: Any) {
        showingFavourites = !showingFavourites
        if #available(iOS 13.0, *) {
            FavouritesButton.setImage(UIImage(systemName: (showingFavourites ? "star.fill" : "star")), for: .normal)
        } else {
            // Fallback on earlier versions
        }
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
}
