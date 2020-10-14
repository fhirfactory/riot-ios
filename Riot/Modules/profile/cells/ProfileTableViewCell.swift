// 
// Copyright 2020 Vector Creations Ltd
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

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var contactIcon: MXKImageView!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var officialName: UILabel!
    
    var delegate: ProfileViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contactIcon.layer.cornerRadius = contactIcon.bounds.height / 2
        contactIcon.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDelegate(delegate: ProfileViewController){
        self.delegate = delegate
        officialName.text = delegate.mainSession.myUser.displayname
        contactIcon.setImageURI(delegate.mainSession.myUser.avatarUrl, withType: nil, andImageOrientation: UIImage.Orientation.up, previewImage: AvatarGenerator.generateAvatar(forText: delegate.mainSession.myUser.displayname), mediaManager: delegate.mainSession.mediaManager)
    }
    
}
