/*
 Copyright 2018 New Vector Ltd

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import Foundation
import UIKit
import DesignKit

/// Color constants for the default theme
@objcMembers
class DefaultTheme: NSObject, Theme {

    var identifier: String = ThemeIdentifier.light.rawValue
    
    var backgroundColor: UIColor = UIColor(rgbHex: 0xFFFFFF)
    var backgroundShadedColor: UIColor = UIColor(rgbHex: 0xDEDEDE)

    var baseColor: UIColor = UIColor(rgbHex: 0xF5F7FA)
    var baseIconPrimaryColor: UIColor = UIColor(rgbHex: 0xFFFFFF)
    var baseTextPrimaryColor: UIColor = UIColor(rgbHex: 0xFFFFFF)
    var baseTextSecondaryColor: UIColor = UIColor(rgbHex: 0x8F97A3)

    var searchBackgroundColor: UIColor = UIColor(rgbHex: 0xFFFFFF)
    var searchPlaceholderColor: UIColor = UIColor(rgbHex: 0x8F97A3)

    var sideMenuProfileBackground: UIColor = UIColor(rgbHex: 0x414141)
    var headerBackgroundColor: UIColor = UIColor(rgbHex: 0xF5F7FA)
    var headerBorderColor: UIColor  = UIColor(rgbHex: 0xE9EDF1)
    var headerTextPrimaryColor: UIColor = UIColor(rgbHex: 0x17191C)
    var headerTextSecondaryColor: UIColor = UIColor(rgbHex: 0x737D8C)

    var textPrimaryColor: UIColor = UIColor(rgbHex: 0x17191C)
    var textSecondaryColor: UIColor = UIColor(rgbHex: 0x737D8C)
    var textTertiaryColor: UIColor = UIColor(rgbHex: 0x8D99A5)

    var tintColor: UIColor = UIColor(displayP3Red: 0.05098039216, green: 0.7450980392, blue: 0.5450980392, alpha: 1.0)
    var tintBackgroundColor: UIColor = UIColor(rgbHex: 0xe9fff9)
    var tabBarUnselectedItemTintColor: UIColor = UIColor(rgbHex: 0xC1C6CD)
    var unreadRoomIndentColor: UIColor = UIColor(rgbHex: 0x2E3648)
    var lineBreakColor: UIColor = UIColor(rgbHex: 0xDDE4EE)
    
    var noticeColor: UIColor = UIColor(rgbHex: 0xFF4B55)
    var noticeSecondaryColor: UIColor = UIColor(rgbHex: 0x61708B)

    var warningColor: UIColor = UIColor(rgbHex: 0xFF4B55)
    
    var roomInputTextBorder: UIColor = UIColor(rgbHex: 0xE3E8F0)

    var avatarColors: [UIColor] = [
        UIColor(rgbHex: 0x03B381),
        UIColor(rgbHex: 0x368BD6),
        UIColor(rgbHex: 0xAC3BA8)]
    
    var userNameColors: [UIColor] = [
        UIColor(rgbHex: 0x368BD6),
        UIColor(rgbHex: 0xAC3BA8),
        UIColor(rgbHex: 0x03B381),
        UIColor(rgbHex: 0xE64F7A),
        UIColor(rgbHex: 0xFF812D),
        UIColor(rgbHex: 0x2DC2C5),
        UIColor(rgbHex: 0x5C56F5),
        UIColor(rgbHex: 0x74D12C)
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
    
    @available(iOS 12.0, *)
    var userInterfaceStyle: UIUserInterfaceStyle {
        return .light
    }

    var placeholderTextColor: UIColor = UIColor(rgbHex: 0x8F97A3) // Use secondary text color
    
    var selectedBackgroundColor: UIColor = UIColor(rgbHex: 0xF5F7FA)
    
    var callScreenButtonTintColor: UIColor = UIColor(rgbHex: 0xFFFFFF)
    
    var overlayBackgroundColor: UIColor = UIColor(white: 0.7, alpha: 0.5)
    var matrixSearchBackgroundImageTintColor: UIColor = UIColor(rgbHex: 0xE7E7E7)
    
    var secondaryCircleButtonBackgroundColor: UIColor = UIColor(rgbHex: 0xE3E8F0)
    
    var shadowColor: UIColor = UIColor(rgbHex: 0x000000)
    
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
    
    ///  MARK: - Theme v2
    
    lazy var colors: Colors = {
        return LightColors()
    }()
}
