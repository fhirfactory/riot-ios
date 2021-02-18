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
    let rolesList = [
        Role(name: "ED Acute SRMO", longname: "Senior Resident Medical Officer", id: "na", description: "Emergency Department Acute Senior Resident Medical Officer", designation: "Senior Resident Medical Officer", category: "Emergency", location: "CH {Canberra Hospital}", orgunit: "ED {Emergency Department}"),
        Role(name: "ED Acute RMO", longname: "Resident Medical Officer", id: "na", description: "Emergency Department Acute Resident Medical Officer", designation: "Resident Medical Officer", category: "Emergency", location: "CH {Canberra Hospital}", orgunit: "ED {Emergency Department}"),
        Role(name: "ED Acute Intern", longname: "Intern", id: "na", description: "Emergency Department Acute Intern", designation: "Intern", category: "Emergency", location: "CH {Canberra Hospital}", orgunit: "ED {Emergency Department}")
    ]
    override func Query(queryDetails: String, success: ([Role]) -> Void, failure: () -> Void) {
        success(rolesList.filter({ (r) -> Bool in
            queryDetails == "" || r.OfficialName.contains(queryDetails) || r.Designation.contains(queryDetails) || r.Name.contains(queryDetails)
        }))
    }
}

class PractitionerRoleQueryService: DebugService {
    func GetRolesForUser(queryDetails: MXUser, success: @escaping ([Role]) -> Void, failure: () -> Void) {
        self.performCallback {
            success([
                        Role(name: "ED Acute SRMO", longname: "Senior Resident Medical Officer", id: "na", description: "Emergency Department Acute Senior Resident Medical Officer", designation: "Senior Resident Medical Officer", category: "Emergency", location: "CH {Canberra Hospital}", orgunit: "ED {Emergency Department}"),
                        Role(name: "ED Acute RMO", longname: "Resident Medical Officer", id: "na", description: "Emergency Department Acute Resident Medical Officer", designation: "Resident Medical Officer", category: "Emergency", location: "CH {Canberra Hospital}", orgunit: "ED {Emergency Department}"),
                        Role(name: "ED Acute Intern", longname: "Intern", id: "na", description: "Emergency Department Acute Intern", designation: "Intern", category: "Emergency", location: "CH {Canberra Hospital}", orgunit: "ED {Emergency Department}")
            ])
        }
    }
}

class RolePractitionerQueryService: DebugService {
    //Query for the practitioners in a role, based on a role's ID
    func GetUsersForRole(queryDetails: Role, success: @escaping ([ActPeople]) -> Void, failure: () -> Void) {
        let session = AppDelegate.theDelegate().mxSessions.first as? MXSession
        var person = ActPeople(withBaseUser: ((AppDelegate.theDelegate().mxSessions.first as? MXSession)?.user(withUserId: session?.myUserId))!, officialName: "Some Name", jobTitle: "App Developer", org: "ACT Health", businessUnit: "I dunno")
        person.emailAddress = "email@email.com"
        person.phoneNumber = "0412345678"
        self.performCallback {
            success([person, person, person])
        }
    }
}
