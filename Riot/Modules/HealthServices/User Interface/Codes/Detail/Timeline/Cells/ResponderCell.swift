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

class ResponderCell: UITableViewCell {
    @IBOutlet weak var AvatarView: MXKImageView!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var RoleLabel: UILabel!
    @IBOutlet weak var AcceptedLabel: UILabel!
    @IBOutlet weak var TimeLabel: UILabel!
    func SetStatus(statusString: String, colour: UIColor){
        AcceptedLabel.text = statusString
        AcceptedLabel.textColor = colour
    }
    
    func SetRoleText(_ text: String) {
        RoleLabel.text = text
    }
    
    func SetName(_ text: String) {
        NameLabel.text = text
        AvatarView.setImageURI(nil, withType: nil, andImageOrientation: .up, previewImage: AvatarGenerator.generateAvatar(forMatrixItem: "matrixItem", withDisplayName: text), mediaManager: nil)
    }
    
    override func awakeFromNib() {
        AvatarView.layer.cornerRadius = AvatarView.frame.width / 2
        AvatarView.layer.masksToBounds = true
        AvatarView.enableInMemoryCache = true
        AvatarView.setImageURI(nil, withType: nil, andImageOrientation: .up, previewImage: AvatarGenerator.generateAvatar(forMatrixItem: "jsmith", withDisplayName: "Smith, John (Health)"), mediaManager: nil)
    }
}
