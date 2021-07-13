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
class RoleQueryService: AsyncQueryableService<PractitionerRole> {
    //Mock data.
    
    override func Query(page: Int, pageSize: Int, queryDetails: String?, success: @escaping ([PractitionerRole], Int) -> Void, failure: () -> Void) {
        let arr = Array(1...250)
        var newArr: [PractitionerRole] = []
        let filtered = arr.filter { a in
            return "Role \(a)".hasPrefix(queryDetails ?? "")
        }
        if page * pageSize < min(filtered.count, page * pageSize + pageSize){
            for i in page*pageSize..<min(filtered.count, page*pageSize+pageSize) {
                newArr.append(MockPractitionerRole(name: "Practitioner \(i)"))
            }
        }
        self.performCallback {
            success(newArr, filtered.count)
        }
    }
    
//    override func Query(queryDetails: String, success: ([Role]) -> Void, failure: () -> Void) {
//        success(rolesList.filter({ (r) -> Bool in
//            queryDetails == "" || r.OfficialName.contains(queryDetails) || r.Designation.contains(queryDetails) || r.Name.contains(queryDetails)
//        }))
//    }
}

class PractitionerRoleQueryService: DebugService {
    func GetRolesForUser(queryDetails: String, success: @escaping ([PractitionerRole]) -> Void, failure: () -> Void) {
        self.performCallback {
            success([
                MockPractitionerRole(name: "Role 1"),
                MockPractitionerRole(name: "Role 2"),
                MockPractitionerRole(name: "Role 3")
            ])
        }
    }
}

class RolePractitionerQueryService: DebugService {
    //Query for the practitioners in a role, based on a role's ID
    func GetUsersForRole(queryDetails: PractitionerRole, success: @escaping ([Practitioner]) -> Void, failure: () -> Void) {
        self.performCallback {
            success([MockPractitioner(name: "Some Name"), MockPractitioner(name: "Another Name"), MockPractitioner(name: "Another Another Name")])
        }
    }
}
