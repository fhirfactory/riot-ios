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
enum CallType {
    case incoming
    case outgoing
    case lingoAudio
    case lingoVideo
    case lingoConference
}


enum CallDirection {
    case incoming
    case outgoing
    case missed
}

class Call {
    var description: String {
        if type == .incoming || type == .outgoing {
            if !knownEntity {
                return Call.description(ofCallType: type)
            }
            if let ph = phoneNumber {
                return ph
            }
        } else {
            return Call.description(ofCallType: type)
        }
        return "ERR"
    }
    let time: Date
    let length: TimeInterval
    let type: CallType
    let with: String
    let knownEntity: Bool
    let phoneNumber: String?
    let extraInfo: ExtraCallInfo?
    let direction: CallDirection
    static func description(ofCallType: CallType) -> String {
        switch ofCallType {
        case .incoming:
            return AlternateHomeTools.getNSLocalized("incoming_call", in: "Vector")
        case .outgoing:
            return AlternateHomeTools.getNSLocalized("outgoing_call", in: "Vector")
        case .lingoAudio:
            return AlternateHomeTools.getNSLocalized("lingo_audio", in: "Vector")
        case .lingoVideo:
            return AlternateHomeTools.getNSLocalized("lingo_video", in: "Vector")
        case .lingoConference:
            return AlternateHomeTools.getNSLocalized("lingo_conference", in: "Vector")
        }
    }
    init(withTime: Date, Length: TimeInterval, Type: CallType, OtherEntity: String, Known: Bool, PhoneNumber: String?, ExtraInfo: ExtraCallInfo?, andDirection: CallDirection) {
        time = withTime
        length = Length
        type = Type
        with = OtherEntity
        knownEntity = Known
        phoneNumber = PhoneNumber
        extraInfo = ExtraInfo
        direction = andDirection
    }
    init(asOutgoingToExternalPhoneNumber phoneNumber: String, withDateTime: Date, andLength: TimeInterval) {
        type = .outgoing
        self.phoneNumber = phoneNumber
        knownEntity = false
        extraInfo = nil
        length = andLength
        time = withDateTime
        with = phoneNumber
        direction = .outgoing
    }
    init(asIncomingFromExternalPhoneNumber phoneNumber: String, withDateTime: Date, andLength: TimeInterval) {
        type = .incoming
        self.phoneNumber = phoneNumber
        knownEntity = false
        extraInfo = nil
        length = andLength
        time = withDateTime
        with = phoneNumber
        direction = .incoming
    }
}

enum InfoType {
    case destination
    case pickedUpBy
}

class ExtraCallInfo {
    let type: InfoType
    var infoString: String {
        switch type {
        case .pickedUpBy:
            return AlternateHomeTools.getNSLocalized("call_picked_up_by", in: "Vector")
        case .destination:
            return AlternateHomeTools.getNSLocalized("call_destination", in: "Vector")
        }
    }
    let data: String
    init(withType: InfoType, andData: String) {
        type = withType
        data = andData
    }
}
