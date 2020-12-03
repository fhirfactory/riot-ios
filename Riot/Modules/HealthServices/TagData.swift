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

@objcMembers class TagData: NSObject {
    let Patients: [PatientModel]
    let Description: String!
    let PhotographerDetails: PhotographerTagDetails?
    let FileContainsPatient: Bool
    init(withPatient: PatientModel, Description: String?, andPhotographer: PhotographerTagDetails?) {
        Patients = [withPatient]
        self.Description = Description
        self.PhotographerDetails = andPhotographer
        FileContainsPatient = true
    }
    init(withPatients: [PatientModel], Description: String?, andPhotographer: PhotographerTagDetails?) {
        Patients = withPatients
        self.Description = Description
        self.PhotographerDetails = andPhotographer
        FileContainsPatient = true
    }
    init(withDescription: String?) {
        self.Description = withDescription
        Patients = []
        FileContainsPatient = false
        PhotographerDetails = nil
    }
}
