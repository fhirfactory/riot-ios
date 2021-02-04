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
///Displays a message like "You haven't marked any Services as favourites." to inform the user of what the favourites filter does.
class NoFavouritesTableViewCell: UITableViewCell {
    @IBOutlet weak var TextContent: UILabel!
    func SetItem(to: String) {
        TextContent.text = String(format: AlternateHomeTools.getNSLocalized("directory_no_favourites_set", in: "Vector"), to.lowercased())
        ThemeService.shared().theme.recursiveApply(on: contentView)
    }
}
