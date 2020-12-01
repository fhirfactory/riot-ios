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

class Services {
    private static var instancePatientQueryService: PatientQueryService!
    static func PatientService() -> PatientQueryService {
        if instancePatientQueryService == nil {
            instancePatientQueryService = PatientQueryService()
        }
        return instancePatientQueryService
    }
    private static var instanceRoleQueryService: RoleQueryService!
    static func RoleService() -> RoleQueryService {
        if instanceRoleQueryService == nil {
            instanceRoleQueryService = RoleQueryService()
        }
        return instanceRoleQueryService
    }
    private static var instanceImageTagService: ImageTagService!
    static func ImageTagDataService() -> ImageTagService {
        if instanceImageTagService == nil {
            instanceImageTagService = ImageTagService()
        }
        return instanceImageTagService
    }
}
