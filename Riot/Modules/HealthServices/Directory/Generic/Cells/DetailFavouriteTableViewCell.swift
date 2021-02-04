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

import SwiftUI

protocol DetailFavouriteTableCellDelegate: class {
    var IsFavourite: Bool {
        get
        set
    }
    
}

class DetailFavouriteTableViewCell: UITableViewCell {
    @IBOutlet weak var FavouriteTitleLabel: UILabel!
    @IBOutlet weak var FavouriteButton: UIButton!
    
    weak var FavouritesDelegate: DetailFavouriteTableCellDelegate!
    var itemTypeString: String!
    
    @IBAction func ToggleFavourite() {
        FavouritesDelegate.IsFavourite = !FavouritesDelegate.IsFavourite
        Render()
    }
    
    func Render() {
        let isFavouriteText = AlternateHomeTools.getNSLocalized("favourite_detail_favourite", in: "Vector")
        let notFavouriteText = AlternateHomeTools.getNSLocalized("favourite_detail_not_favourite", in: "Vector")
        let favouriteText = FavouritesDelegate.IsFavourite ? isFavouriteText : notFavouriteText
        FavouriteTitleLabel.text = String(format: favouriteText ?? "missing string", itemTypeString.lowercased())
        FavouriteButton.setTitle(FavouritesDelegate.IsFavourite == false ? AlternateHomeTools.getNSLocalized("favourite_detail_mark", in: "Vector") : AlternateHomeTools.getNSLocalized("favourite_detail_unmark", in: "Vector"), for: .normal)
        ThemeService.shared().theme.recursiveApply(on: contentView)
    }
    
}
