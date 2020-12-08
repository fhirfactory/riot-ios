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

class ImageDescriptionCell: UITableViewCell, UITextViewDelegate {
    @IBOutlet weak var DescriptionTitle: UILabel!
    @IBOutlet weak var DescriptionLabel: UILabel!
    @IBOutlet weak private var DescriptionTextView: UITextView!
    var displayingPlaceholder: Bool = true
    var placeholderText: String {
        return AlternateHomeTools.getNSLocalized("", in: "Vector")
    }
    weak private var viewModel: PatientTaggingViewModel?
    
    func drawPlaceholderText(placeholder: String, textView: UITextView) {
        if !(DescriptionTextView.text == "" || DescriptionTextView.text == nil) {
            return
        }
        displayingPlaceholder = true
        textView.text = placeholder
        textView.textColor = ThemeService.shared().theme.textSecondaryColor
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if displayingPlaceholder {
            textView.text = nil
            textView.textColor = ThemeService.shared().theme.textPrimaryColor
        }
        displayingPlaceholder = false
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == nil || textView.text == "" {
            drawPlaceholderText(placeholder: AlternateHomeTools.getNSLocalized("image_description_placeholder", in: "Vector"), textView: textView)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        viewModel?.description = displayingPlaceholder ? nil : textView.text
        return true
    }
    
    func render(viewModel: PatientTaggingViewModel) {
        self.viewModel = viewModel
        if viewModel.description != nil {
            DescriptionTextView.text = viewModel.description
            DescriptionLabel.text = viewModel.description
            DescriptionLabel.isHidden = true
            displayingPlaceholder = false
        }
        ThemeService.shared().theme.recursiveApply(on: self.contentView)
        drawPlaceholderText(placeholder: AlternateHomeTools.getNSLocalized("image_description_placeholder", in: "Vector"), textView: DescriptionTextView)
        DescriptionTitle.text = AlternateHomeTools.getNSLocalized("image_description_name", in: "Vector")
        
    }
    
    func setAsReadOnly() {
        DescriptionTextView.isHidden = true
        DescriptionLabel.isHidden = false
    }
    
    func forceResignFirstResponder() {
        viewModel?.description = displayingPlaceholder ? nil : DescriptionTextView.text
        DescriptionTextView.resignFirstResponder()
    }
}
