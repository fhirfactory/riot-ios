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

class PatientQueryService: AsyncQueryableService<PatientModel>{
    let patientList = [PatientModel(Name: "John Somebody", URN: "123456789", DoB: Date()), PatientModel(Name: "John The Nobody", URN: "987654321", DoB: Date()), PatientModel(Name: "Jill Bejonassie", URN: "234987234", DoB: Date())]
    override func Query(queryDetails: String, success: ([PatientModel]) -> Void, failure: () -> Void){
        success(patientList.filter({ (patient) -> Bool in
            queryDetails == "" || patient.URN.contains(queryDetails) || patient.Name.contains(queryDetails)
        }))
    }
}
