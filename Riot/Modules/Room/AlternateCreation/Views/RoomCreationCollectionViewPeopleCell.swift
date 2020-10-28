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

class RoomCreationCollectionViewPeopleCellRenderer {
    static func GetRendererFor(_ person: ActPeople) -> (RoomCreationCollectionViewCell) -> Void {
        return {(value) in
            let session = (AppDelegate.theDelegate().mxSessions.first as? MXSession)
            let previewAvatar = AvatarGenerator.generateAvatar(forText: person.officialName)
            value.AvatarView.enableInMemoryCache = true
            value.AvatarView.setImageURI(person.baseUser.avatarUrl, withType: nil, andImageOrientation: UIImage.Orientation.up, previewImage: previewAvatar, mediaManager: session?.mediaManager) //this line is a memory leak
            value.AvatarView.layer.cornerRadius = value.AvatarView.frame.width / 2
            value.AvatarView.layer.masksToBounds = true
            value.Presence.layer.cornerRadius = value.Presence.frame.width / 2
            value.Presence.layer.masksToBounds = true
            value.Name.text = person.officialName
            value.Presence.backgroundColor = person.baseUser.presence == MXPresenceOnline ? UIColor.green : UIColor.gray
        }
    }
}
