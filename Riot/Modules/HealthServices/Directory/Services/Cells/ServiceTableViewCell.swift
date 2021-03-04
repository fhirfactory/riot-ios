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
class ServiceTableViewCell: UITableViewCell {
    @IBOutlet weak var ServiceName: UILabel!
    @IBOutlet weak var LocationTitle: UILabel!
    @IBOutlet weak var LocationFirstLine: UILabel!
    @IBOutlet weak var LocationSecondLine: UILabel!
    @IBOutlet weak var FavouriteButton: UIButton!
    var Service: ServiceModel!
    var Delegate: FavouriteActionReceiverDelegate!
    func setService(toService: ServiceModel, withFavouritesDelegate: FavouriteActionReceiverDelegate) {
        Delegate = withFavouritesDelegate
        Service = toService
        ServiceName.text = toService.Name
        LocationTitle.text = AlternateHomeTools.getNSLocalized("service_detail_location_title", in: "Vector")
        LocationFirstLine.text = toService.LocationFirstLine
        LocationSecondLine.text = toService.LocationSecondLine
        if #available(iOS 13.0, *) {
            FavouriteButton.setImage(UIImage(systemName: (toService.Favourite ? "star.fill" : "star")), for: .normal)
        } else {
            // Fallback on earlier versions
        }
    }
    override func awakeFromNib() {
        ThemeService.shared().theme.recursiveApply(on: self.contentView)
    }
    @IBAction private func FavouriteButtonPressed(_ sender: Any) {
        Service.Favourite = !Service.Favourite
        
        if #available(iOS 13.0, *) {
            FavouriteButton.setImage(UIImage(systemName: (Service.Favourite ? "star.fill" : "star")), for: .normal)
        } else {
            // Fallback on earlier versions
        }
        
        Delegate.favouritesUpdated(favourited: Service.Favourite)
    }
}
