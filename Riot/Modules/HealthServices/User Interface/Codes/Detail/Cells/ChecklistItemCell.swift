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

class ChecklistItemCell: UITableViewCell {
    var Index: Int = 0
    var delegate: ChecklistItemDelegate!
    @IBOutlet weak var RoleNameLabel: UILabel!
    @IBOutlet weak var AcceptedLabel: UILabel!
    @IBOutlet weak var RequiredLabel: UILabel!
    @IBOutlet weak var StatusLabel: UILabel!
    var RoleName: String!
    var ResponderGroup: ResponderGroup!
    @IBAction func expandButtonPressed() {
        delegate?.didExpandChecklistItem(index: Index)
    }
    func SetResponderGroup(Group: ResponderGroup) {
        ResponderGroup = Group
        SetRole(Group.Name)
        SetAccepted(Accepted: Group.Responders.count, OfRequired: Group.RequiredCount)
    }
    func SetRole(_ text: String) {
        RoleNameLabel.text = "(Required) \(text)"
        RoleName = text
    }
    func SetAccepted(Accepted: Int, OfRequired: Int) {
        AcceptedLabel.text = "Accepted: \(Accepted)"
        RequiredLabel.text = "Required: \(OfRequired)"
        if Accepted >= OfRequired {
            StatusLabel.text = "✔️"
        } else {
            StatusLabel.text = "❌"
        }
    }
}
