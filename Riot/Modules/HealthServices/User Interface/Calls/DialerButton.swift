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

class DialerButton: UIView {
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    static func nib() -> UINib! {
        UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
    
    func load(withNumber number: String, andAlphabet subtitle: String) {
        guard let nib = type(of: self).nib() else { return }
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        view.backgroundColor = .none
        self.backgroundColor = .none
        addConstraints([
            NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0)
        ])
        subtitleLabel.textColor = ThemeService.shared().theme.textPrimaryColor
        numberLabel.textColor = ThemeService.shared().theme.textPrimaryColor
        numberLabel.text = number
        subtitleLabel.text = subtitle
        
        view.backgroundColor = ThemeService.shared().theme.tintBackgroundColor
    }
}
