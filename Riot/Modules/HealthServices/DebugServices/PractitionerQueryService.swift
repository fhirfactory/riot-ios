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

class PractitionerQueryService: AsyncQueryableService<Practitioner> {
    override func Query(page: Int, pageSize: Int, queryDetails: String?, success: @escaping ([Practitioner], Int) -> Void, failure: () -> Void) {
        let arr = Array(1...250)
        var newArr: [Practitioner] = []
        let filtered = arr.filter { a in
            return "Person \(a)".hasPrefix(queryDetails ?? "")
        }
        let low = page*pageSize
        let high = min(filtered.count, page*pageSize+pageSize)
        let session = AppDelegate.theDelegate().mxSessions.first as? MXSession
        if low < high {
            for i in low..<high {
                newArr.append(MockPractitioner(name: "Person \(filtered[i])"))
            }
        }
        self.performCallback {
            success(newArr, filtered.count)
        }
    }
}
