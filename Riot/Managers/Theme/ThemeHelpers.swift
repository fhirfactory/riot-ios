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

extension Theme {
    func recursiveApply(on view: UIView, onlyDrawBackgroundOnce: Bool = false, _ ignoreBackground: Bool = false, onlyReplaceSystemBackgroundColors: Bool = false) {
        switch view {
//        case is MinimalSearchBar:
//            guard let searchBar = view as? MinimalSearchBar else { return }
//            searchBar.searchBarStyle = .minimal
//            searchBar.barTintColor = .none
//            searchBar.isTranslucent = true
//            searchBar.backgroundImage = UIImage() // Remove top and bottom shadow
//            searchBar.tintColor = tintColor
//            
//            if #available(iOS 13.0, *) {
//                searchBar.searchTextField.backgroundColor = .white
//                searchBar.searchTextField.textColor = self.textSecondaryColor
//                if let glassIconView = searchBar.searchTextField.leftView as? UIImageView {
//                    
//                    //Magnifying glass
//                    glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
//                    glassIconView.tintColor = textPrimaryColor
//                }
//            } else {
//                if let searchBarTextField = searchBar.vc_searchTextField {
//                    searchBarTextField.textColor = self.searchPlaceholderColor
//                }
//            }
        case is UIButton:
            guard let v = view as? UIButton else { return } //Literally impossible for this to error, but Apple won't let you force cast here for some reason
            self.applyStyle(onButton: v)
        case is UILabel:
            guard let label = view as? UILabel else { return } //Again, impossible for this to error
            label.textColor = self.textPrimaryColor
        case is UITextField:
            guard let v = view as? UITextField else { return }
            self.applyStyle(onTextField: v)
        case is UISearchBar:
            guard let v = view as? UISearchBar else { return }
            self.applyStyle(onSearchBar: v)
        case is UITableView:
            guard let v = view as? UITableView else { return }
            v.backgroundColor = self.backgroundColor
            v.backgroundView?.backgroundColor = self.backgroundColor
            v.separatorColor = self.textSecondaryColor
        case is UITextView:
            guard let v = view as? UITextView else { return }
            v.backgroundColor = self.backgroundColor
            v.textColor = self.textPrimaryColor
        default:
            var isTableViewCellContent = false
            if let sv = view.superview {
                isTableViewCellContent = sv is UITableViewCell
            }
            if type(of: view) == UIView.self || view is UIStackView || isTableViewCellContent {
                
                if #available(iOS 13.0, *), onlyReplaceSystemBackgroundColors && view.backgroundColor != UIColor.systemBackground {
                    
                } else {
                    if !ignoreBackground {
                        view.backgroundColor = self.backgroundColor
                    } else if onlyDrawBackgroundOnce {
                        view.backgroundColor = .none
                    }
                }
                for v in view.subviews {
                    recursiveApply(on: v, onlyDrawBackgroundOnce: onlyDrawBackgroundOnce, onlyDrawBackgroundOnce)
                }
            }
        }
    }
}

class ObjcThemeHelpers: NSObject {
    @objc static func recursiveApply(theme: Theme, onView view: UIView) {
        theme.recursiveApply(on: view)
    }
}
