// 
// Copyright 2020 Vector Creations Ltd
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

struct LocalRole {
    let name:String
    let active: Bool
}

enum SideMenuOption {
    case Roles
    case SignOut
    case Settings
    var StringIdentifier: String {
        switch self {
        case .Roles:
            return "settings_roles"
        case .Settings:
            return "settings_settings"
        case .SignOut:
            return "settings_sign_out"
        }
    }
}

struct IconItem {
    let image: UIImage
    var text: String {
        return NSLocalizedString(item.StringIdentifier, tableName: "Vector", bundle: Bundle.main, value: "", comment: "")
    }
    let item: SideMenuOption
}

struct TextItem {
    let text: String
    let url: String
}
