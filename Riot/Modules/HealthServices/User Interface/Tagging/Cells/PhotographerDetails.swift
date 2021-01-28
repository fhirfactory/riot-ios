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

class PhotographerDetails: UITableViewCell {
    @IBOutlet weak var PhotographerTitle: UILabel!
    @IBOutlet weak var PhotographerName: UILabel!
    @IBOutlet weak var DesignationTitle: UILabel!
    @IBOutlet weak var DesignationSelector: UIButton!
    @IBOutlet weak var DesignationLabel: UILabel!
    var selectedDesignation: Role?
    private var roleSelectionChanged: ((Role) -> Void)?
    @IBAction private func DesignationSelectorClicked(_ sender: Any) {
        let selectDesignationVC = FilteredSearchPopoverViewController<Role>(withScrollHandler: nil, andViewCellReuseID: "DesignationViewCell", andService: Services.RoleService())
        selectDesignationVC.onSelectedCallback = {(designation) in
            self.selectedDesignation = designation
            self.drawText()
            (self.roleSelectionChanged ?? {(d) in })(designation)
        }
        nearestViewController?.present(selectDesignationVC, animated: true, completion: nil)
    }
    
    func drawText() {
        DesignationSelector.setTitle(selectedDesignation?.Designation ?? AlternateHomeTools.getNSLocalized("designation_select", in: "Vector"), for: .normal)
    }
    
    weak var nearestViewController: UIViewController? //avoid ref cycles
    func applyTheme() {
        ThemeService.shared().theme.recursiveApply(on: contentView)
        drawText()
    }
    
    func setRole(to role: Role?) {
        selectedDesignation = role
        drawText()
        guard let session = AppDelegate.theDelegate().mxSessions.first as? MXSession else { return }
        PhotographerName.text = session.myUser.displayname
        DesignationLabel.isHidden = true
    }
    
    func setChangeHandler(to handler: ((Role) -> Void)?) {
        roleSelectionChanged = handler
    }
    
    func displayDetails(photographerTagDetails: PhotographerTagDetails) {
        DesignationLabel.isHidden = false
        DesignationSelector.isHidden = true
        applyTheme()
        PhotographerName.text = photographerTagDetails.Name
        DesignationLabel.text = photographerTagDetails.Role.Designation
    }
}
