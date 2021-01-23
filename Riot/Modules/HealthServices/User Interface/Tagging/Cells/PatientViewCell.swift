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

class PatientViewCell: QueryTableViewCell<PatientModel> {
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var URNLabel: UILabel!
    @IBOutlet weak var DateOfBirthLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func disableViews() {
        NameLabel.isHidden = true
        URNLabel.isHidden = true
        DateOfBirthLabel.isHidden = true
    }
    
    func enableViews() {
        NameLabel.isHidden = false
        URNLabel.isHidden = false
        DateOfBirthLabel.isHidden = false
    }
    
    override func RenderWith(Object value: PatientModel) {
        super.RenderWith(Object: value)
        contentView.backgroundColor = ThemeService.shared().theme.backgroundColor
        accessoryView?.backgroundColor = ThemeService.shared().theme.backgroundColor
        NameLabel.textColor = ThemeService.shared().theme.textPrimaryColor
        URNLabel.textColor = ThemeService.shared().theme.textPrimaryColor
        DateOfBirthLabel.textColor = ThemeService.shared().theme.textPrimaryColor
        let formatter = DateFormatter()
        formatter.dateFormat = "d-MMM-yyyy"
        DateOfBirthLabel.text = formatter.string(from: value.DoB)
        URNLabel.text = value.URN
        let nameStringDetails = PatientModel.ReorderNameString(Name: value.Name)
        let nameString = nameStringDetails.1 + ", " + nameStringDetails.0
        let attributedNameString = NSMutableAttributedString(string: nameString)
        attributedNameString.beginEditing()
        attributedNameString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: NameLabel.fontSize), range: _NSRange(location: 0, length: nameStringDetails.1.count))
        attributedNameString.endEditing()
        NameLabel.attributedText = attributedNameString
    }
}
