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
    var tagData: [String: [TagData]] = ["mxc://matrix.org/EzgHluUEbwnEGDZHpcwaJTNy":[
                                            TagData(withPatient: PatientModel(Name: "John Somebody", URN: "123456789", DoB: Date()), Description: "A photo taken of a patient that has mysteriously become a somewhat monolithic building in Canberra. Shown is the patient's left arm.", Photographer: PhotographerTagDetails(withName: "Jill", andRole: Role(withName: "Aboriginal Liason", andId: "aaa-bbb-ccc", andDescription: "I dunno")), andDate: Date()),
                                            TagData(withPatient: PatientModel(Name: "John Nobody", URN: "123456788", DoB: Date()), Description: "A photo taken of a patient that has mysteriously become a somewhat monolithic building in Canberra. Shown is the patient's *right* arm (a clerical error had this incorrectly described as the patient's left arm).", Photographer: PhotographerTagDetails(withName: "Jill", andRole: Role(withName: "Aboriginal Liason", andId: "aaa-bbb-ccc", andDescription: "I dunno")), andDate: Date())]]
    func LookupTagInfoFor(URL: String, andHandler handler: ([TagData]) -> Void) {
        if tagData.keys.contains(URL) {
            if let tags = tagData[URL] {
                handler(tags)
            }
        }
    }
    //first tag in the array is the oldest tag; last in the array is the most recent tag. (tags are in chronological order)
    @objc func LookupTagInfoForObjc(URL: String, andHandler handler: (NSArray) -> Void) {
        if tagData.keys.contains(URL) {
            if let tags = tagData[URL] {
                handler(tags as NSArray)
            }
        }
    }
}
