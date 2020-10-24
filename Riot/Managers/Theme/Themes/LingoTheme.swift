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
import UIKit

/// Color constants for the ACT Health Lingo customisation
@objcMembers
class LingoTheme: NSObject, Theme {

    var identifier: String = "lingo"
    
    var backgroundColor: UIColor = UIColor(unused: true, rgb: 0xFFFFFF)

    var baseColor: UIColor = UIColor(unused: true, rgb: 0xF5F7FA)
    var baseIconPrimaryColor: UIColor = UIColor(unused: true, rgb: 0xFFFFFF)
    var baseTextPrimaryColor: UIColor = UIColor(unused: true, rgb: 0xFFFFFF)
    var baseTextSecondaryColor: UIColor = UIColor(unused: true, rgb: 0x8F97A3)

    var searchBackgroundColor: UIColor = UIColor(unused: true, rgb: 0xFFFFFF)
    var searchPlaceholderColor: UIColor = UIColor(unused: true, rgb: 0x8F97A3)

    var headerBackgroundColor: UIColor = UIColor(unused: true, rgb: 0xF5F7FA)
    var headerBorderColor: UIColor  = UIColor(unused: true, rgb: 0xE9EDF1)
    var headerTextPrimaryColor: UIColor = UIColor(unused: true, rgb: 0x171910)
    var headerTextSecondaryColor: UIColor = UIColor(unused: true, rgb: 0x8F97A3)

    var textPrimaryColor: UIColor = UIColor(unused: true, rgb: 0x171910)
    var textSecondaryColor: UIColor = UIColor(unused: true, rgb: 0x8F97A3)

    var tintColor: UIColor = UIColor(unused: true, rgb: 0x3d7bff)
    var tintBackgroundColor: UIColor = UIColor(unused: true, rgb: 0xe9f0ff)
    var tabBarUnselectedItemTintColor: UIColor = UIColor(unused: true, rgb: 0xC1C6CD)
    var unreadRoomIndentColor: UIColor = UIColor(unused: true, rgb: 0x2E3648)
    var lineBreakColor: UIColor = UIColor(unused: true, rgb: 0xDDE4EE)
    
    var noticeColor: UIColor = UIColor(unused: true, rgb: 0xFF4B55)
    var noticeSecondaryColor: UIColor = UIColor(unused: true, rgb: 0x61708B)

    var warningColor: UIColor = UIColor(unused: true, rgb: 0xFF4B55)

    var avatarColors: [UIColor] = [
        UIColor(unused: true, rgb: 0x03B381),
        UIColor(unused: true, rgb: 0x368BD6),
        UIColor(unused: true, rgb: 0xAC3BA8)]
    
    var userNameColors: [UIColor] = [
        UIColor(unused: true, rgb: 0x368BD6),
        UIColor(unused: true, rgb: 0xAC3BA8),
        UIColor(unused: true, rgb: 0x03B381),
        UIColor(unused: true, rgb: 0xE64F7A),
        UIColor(unused: true, rgb: 0xFF812D),
        UIColor(unused: true, rgb: 0x2DC2C5),
        UIColor(unused: true, rgb: 0x5C56F5),
        UIColor(unused: true, rgb: 0x74D12C)
    ]
    
    var statusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    var scrollBarStyle: UIScrollView.IndicatorStyle = .default
    var keyboardAppearance: UIKeyboardAppearance = .light

    var placeholderTextColor: UIColor = UIColor(unused: true, rgb: 0x8F97A3) // Use secondary text color
    
    var selectedBackgroundColor: UIColor = UIColor(unused: true, rgb: 0xF5F7FA)
    
    var overlayBackgroundColor: UIColor = UIColor(white: 0.7, alpha: 0.5)
    var matrixSearchBackgroundImageTintColor: UIColor = UIColor(unused: true, rgb: 0xE7E7E7)
    
    func applyStyle(onTabBar tabBar: UITabBar) {
        tabBar.unselectedItemTintColor = self.tabBarUnselectedItemTintColor
        tabBar.tintColor = self.tintColor
        tabBar.barTintColor = self.baseColor
        tabBar.isTranslucent = false
    }
    
    // Note: We are not using UINavigationBarAppearance on iOS 13+ atm because of UINavigationBar directly include UISearchBar on their titleView that cause crop issues with UINavigationController pop.
    func applyStyle(onNavigationBar navigationBar: UINavigationBar) {
        navigationBar.tintColor = self.tintColor
        navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: self.textPrimaryColor
        ]
        navigationBar.barTintColor = self.baseColor
        navigationBar.shadowImage = UIImage() // Remove bottom shadow

        // The navigation bar needs to be opaque so that its background color is the expected one
        navigationBar.isTranslucent = false
    }
    
    func applyStyle(onSearchBar searchBar: UISearchBar) {
        searchBar.searchBarStyle = .default
        searchBar.barTintColor = self.baseColor
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage() // Remove top and bottom shadow
        searchBar.tintColor = self.tintColor
        
        if #available(iOS 13.0, *) {
            searchBar.searchTextField.backgroundColor = self.searchBackgroundColor
            searchBar.searchTextField.textColor = self.searchPlaceholderColor
        } else {
            if let searchBarTextField = searchBar.vc_searchTextField {
                searchBarTextField.textColor = self.searchPlaceholderColor
            }
        }
    }
    
    func applyStyle(onTextField texField: UITextField) {
        texField.textColor = self.textPrimaryColor
        texField.tintColor = self.tintColor
    }
    
    func applyStyle(onButton button: UIButton) {
        // NOTE: Tint color does nothing by default on button type `UIButtonType.custom`
        button.tintColor = self.tintColor
        button.setTitleColor(self.tintColor, for: .normal)
    }
}
