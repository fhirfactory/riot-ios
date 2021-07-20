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

//TODO: Update functionality when backend is in place
class PatientQueryService: AsyncQueryableService<PatientModel>, DataQueryService {
    typealias ReturnType = PatientModel
    
    //These default patients are here to provide a mock beckend, and will be removed when the backend is implemented
    let patientList = [PatientModel(Name: "John Somebody", URN: "123456789", DoB: Date()), PatientModel(Name: "John The Nobody", URN: "987654321", DoB: Date()), PatientModel(Name: "Jill Bejonassie", URN: "234987234", DoB: Date())]
    
    func SearchResources(query: String?, page: Int, pageSize: Int, withSuccessCallback success: (([PatientModel], Int) -> Void)?, andFailureCallback failure: ((Error?) -> Void)?) {
        let arr = Array(1...250)
        var newArr: [PatientModel] = []
        let filtered = arr.filter { a in
            return "Patient \(a)".hasPrefix(query ?? "")
        }
        let low = page*pageSize
        let high = min(filtered.count, page*pageSize+pageSize)
        if low < high {
            for i in low..<high {
                newArr.append(PatientModel(Name: "Patient \(filtered[i])", URN: String(i), DoB: Date()))
            }
        }
        success?(newArr, filtered.count)
    }
}
