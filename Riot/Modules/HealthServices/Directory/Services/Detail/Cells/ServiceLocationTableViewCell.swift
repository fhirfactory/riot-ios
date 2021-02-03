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

class ServiceLocationTableViewCell: UITableViewCell {
    @IBOutlet weak var LocationTitle: UILabel!
    @IBOutlet weak var LocationFirstLine: UILabel!
    @IBOutlet weak var LocationSecondLine: UILabel!
    override func awakeFromNib() {
        ThemeService.shared().theme.recursiveApply(on: contentView)
        LocationTitle.text = AlternateHomeTools.getNSLocalized("service_detail_location_title", in: "Vector")
    }
    func SetService(toService: Service) {
        LocationFirstLine.text = toService.LocationFirstLine
        LocationSecondLine.text = toService.LocationSecondLine
    }
}
