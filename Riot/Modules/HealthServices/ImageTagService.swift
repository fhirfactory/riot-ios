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

@objc class ImageTagService: NSObject {
    //Effectively a stub function, provides mock tag data on every image
    func LookupTagInfoFor(URL: String, andHandler handler: ([TagData]) -> Void) {
        handler([TagData(withPatient: PatientModel(Name: "John Somebody", URN: "123456789", DoB: Date()), Description: "A photo taken of a patient's arm, showing growths developing on their upper forearm.", Photographer: PhotographerTagDetails(withName: "Jill", andRole: Role(withName: "Aboriginal Liason", andId: "aaa-bbb-ccc", andDescription: "I dunno")), andDate: Date()),
            TagData(withPatient: PatientModel(Name: "John Nobody", URN: "123456788", DoB: Date()), Description: "A photo taken of a patient's arm, showing the development of growths on their upper forearm. A biopsy confirmed the growths to be benign cysts, in need of no further examination.", Photographer: PhotographerTagDetails(withName: "Jill", andRole: Role(withName: "Aboriginal Liason", andId: "aaa-bbb-ccc", andDescription: "I dunno")), andDate: Date())
        ])
    }
    //first tag in the array is the oldest tag; last in the array is the most recent tag. (tags are in chronological order)
    @objc func LookupTagInfoForObjc(URL: String, andHandler handler: (NSArray) -> Void) {
        LookupTagInfoFor(URL: URL, andHandler: {(data) in
            handler(data as NSArray)
        })
    }
}
