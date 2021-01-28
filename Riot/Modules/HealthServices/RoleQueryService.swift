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

//TODO: Update functionality when backend is completed
class RoleQueryService: AsyncQueryableService<Role> {
    //Mock data.
    let rolesList = [Role(withName: "Aboriginal Liason", andId: "aaa-bbb-ccc", andDescription: "I dunno"), Role(withName: "After Hours Hospital Manager (AHHM)", andId: "xxx-yyy-zzz", andDescription: "I dunno"), Role(withName: "Doctor", andId: "sss-ddd-fff", andDescription: "Okay")]
    override func Query(queryDetails: String, success: ([Role]) -> Void, failure: () -> Void) {
        success(rolesList.filter({ (r) -> Bool in
            queryDetails == "" || r.Description.contains(queryDetails) || r.Designation.contains(queryDetails) || r.Name.contains(queryDetails)
        }))
    }
}
