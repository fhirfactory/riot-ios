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

@objc class Services: NSObject {
    private static var loggedInUserIdentity: String!
    static func setUser(emailAddress: String) {
        loggedInUserIdentity = emailAddress
    }
    static func getUser() -> String {
        loggedInUserIdentity
    }
    
    private static var instancePatientQueryService: PatientQueryService!
    static func PatientService() -> PatientQueryService {
        if instancePatientQueryService == nil {
            instancePatientQueryService = PatientQueryService()
        }
        return instancePatientQueryService
    }
    private static var instanceImageTagService: ImageTagService!
    @objc static func ImageTagDataService() -> ImageTagService {
        if instanceImageTagService == nil {
            instanceImageTagService = ImageTagService()
        }
        return instanceImageTagService
    }
    private static var instancePractitionerRoleService: PractitionerRoleAPIService!
    static func PractitionerRoleService() -> PractitionerRoleAPIService {
        if instancePractitionerRoleService == nil {
            instancePractitionerRoleService = PractitionerRoleAPIService()
        }
        return instancePractitionerRoleService
    }
    private static var instancePractitionerService: PractitionerAPIService!
    static func PractitionerService() -> PractitionerAPIService {
        if instancePractitionerService == nil {
            instancePractitionerService = PractitionerAPIService()
        }
        return instancePractitionerService
    }
}
