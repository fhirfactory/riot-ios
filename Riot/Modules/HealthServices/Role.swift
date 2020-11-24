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

class Role: Equatable {
    static func == (lhs: Role, rhs: Role) -> Bool {
        lhs.Identifier == rhs.Identifier && lhs.Name == rhs.Name
    }
    
    let Name: String
    let Identifier: String
    let Description: String
    let Designation: String
    init(withName n: String, andId id: String, andDescription desc: String) {
        Name = n
        Identifier = id
        Description = desc
        Designation = n
    }
    init(withName n: String, andId id: String, andDescription desc: String, andDesignation des: String) {
        Name = n
        Identifier = id
        Description = desc
        Designation = des
    }
    func getRoleModel() -> RoleModel {
        return RoleModel(name: Name, description: Description, isExpanded: false)
    }
}
