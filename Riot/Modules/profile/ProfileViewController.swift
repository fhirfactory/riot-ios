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

private enum SectionType: Int, CaseIterable {
    case PROFILE_CELL = 0
    case ROLE_CELL = 1
    case ROLE_DIVIDER_CELL = 2
    case ICON_ITEM_CELL = 3
    case ICON_ITEM_DIVIDER_CELL = 4
    case ONLY_TEXT_CELL = 5
    
    
    var cellIdentifier: String {
        switch self {
        case .PROFILE_CELL:
            return "ProfileTableViewCell"
        case .ROLE_CELL:
            return "ProfileRoleTableViewCell"
        case .ICON_ITEM_CELL:
            return "DrawerItemTableViewCell"
        case .ONLY_TEXT_CELL:
            return "DrawerTextTableViewCell"
        case .ICON_ITEM_DIVIDER_CELL, .ROLE_DIVIDER_CELL:
            return "ProfileSectionDividerTableViewCell"
        }
    }
}

class ProfileViewController: MXKViewController {
    @IBOutlet weak var tableView: UITableView!
    var theme: Theme = ThemeService.shared().theme
    
    var roles: [Role] = []
    var iconItems: [IconItem] = []
    var textItems: [TextItem] = []
    
    let signOutAlertPresenter = SignOutAlertPresenter()
    
    override func finalizeInit() {
        super.finalizeInit()
        // Setup `MXKViewControllerHandling` properties
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add each matrix session, to update the view controller appearance according to mx sessions state
        if let sessions = AppDelegate.the().mxSessions {
            for mxSession in sessions {
                guard let mxSession = mxSession as? MXSession else {
                    continue
                }
                addMatrixSession(mxSession)
            }
        }
        
        signOutAlertPresenter.delegate = self
        
        //hiding the navigation bar's shadow
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: SectionType.PROFILE_CELL.cellIdentifier, bundle: nil), forCellReuseIdentifier: SectionType.PROFILE_CELL.cellIdentifier)
        tableView.register(UINib(nibName: SectionType.ROLE_CELL.cellIdentifier, bundle: nil), forCellReuseIdentifier: SectionType.ROLE_CELL.cellIdentifier)
        tableView.register(UINib(nibName: SectionType.ICON_ITEM_CELL.cellIdentifier, bundle: nil), forCellReuseIdentifier: SectionType.ICON_ITEM_CELL.cellIdentifier)
        tableView.register(UINib(nibName: SectionType.ONLY_TEXT_CELL.cellIdentifier, bundle: nil), forCellReuseIdentifier: SectionType.ONLY_TEXT_CELL.cellIdentifier)
        tableView.register(UINib(nibName: SectionType.ROLE_DIVIDER_CELL.cellIdentifier, bundle: nil), forCellReuseIdentifier: SectionType.ROLE_DIVIDER_CELL.cellIdentifier)
        
        roles.append(Role(name: "Software Developer", active: true))
        roles.append(Role(name: "Business Analyst", active: false))
        roles.append(Role(name: "UI Designer", active: false))
        
        iconItems.append(IconItem(image: UIImage(named: "settings_icon") ?? UIImage(), text: "Settings"))
        iconItems.append(IconItem(image: UIImage(named: "role_outline") ?? UIImage(), text: "Roles"))
        iconItems.append(IconItem(image: UIImage(named: "exit") ?? UIImage(), text: "Sign out"))
        
        textItems.append(TextItem(text: NSLocalizedString("settings_term_conditions", tableName: "Vector", bundle: Bundle.main, value: "", comment: ""), url: ""))
        textItems.append(TextItem(text: NSLocalizedString("settings_privacy_policy", tableName: "Vector", bundle: Bundle.main, value: "", comment: ""), url: ""))
        textItems.append(TextItem(text: "Acknowledgement", url: ""))
        textItems.append(TextItem(text: "Version ... ", url: ""))
    }
    
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case SectionType.ROLE_DIVIDER_CELL.rawValue, SectionType.ICON_ITEM_DIVIDER_CELL.rawValue:
            return 1
        case SectionType.PROFILE_CELL.rawValue:
            return 1
        case SectionType.ROLE_CELL.rawValue:
            return roles.count
        case SectionType.ICON_ITEM_CELL.rawValue:
            return iconItems.count
        case SectionType.ONLY_TEXT_CELL.rawValue:
            return textItems.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case SectionType.PROFILE_CELL.rawValue:
            guard let profileCell = self.tableView.dequeueReusableCell(withIdentifier: SectionType.PROFILE_CELL.cellIdentifier, for: indexPath) as? ProfileTableViewCell else { return UITableViewCell() }
            profileCell.selectionStyle = .none
            return profileCell
        case SectionType.ROLE_CELL.rawValue:
            guard let roleCell = self.tableView.dequeueReusableCell(withIdentifier: SectionType.ROLE_CELL.cellIdentifier, for: indexPath) as? ProfileRoleTableViewCell else { return UITableViewCell() }
            roleCell.setValue(role: roles[indexPath.row])
            roleCell.selectionStyle = .none
            return roleCell
        case SectionType.ICON_ITEM_CELL.rawValue:
            guard let iconItemCell = self.tableView.dequeueReusableCell(withIdentifier: SectionType.ICON_ITEM_CELL.cellIdentifier, for: indexPath) as? DrawerItemTableViewCell else { return UITableViewCell() }
            iconItemCell.setValue(iconItem: iconItems[indexPath.row])
            iconItemCell.selectionStyle = .default
            return iconItemCell
        case SectionType.ONLY_TEXT_CELL.rawValue:
            guard let textCell = self.tableView.dequeueReusableCell(withIdentifier: SectionType.ONLY_TEXT_CELL.cellIdentifier, for: indexPath) as? DrawerTextTableViewCell else { return UITableViewCell() }
            textCell.setValue(textItem: textItems[indexPath.row])
            textCell.selectionStyle = .default
            return textCell
        case SectionType.ROLE_DIVIDER_CELL.rawValue, SectionType.ICON_ITEM_DIVIDER_CELL.rawValue:
            guard let dividerCell = self.tableView.dequeueReusableCell(withIdentifier: SectionType.ICON_ITEM_DIVIDER_CELL.cellIdentifier, for: indexPath) as? ProfileSectionDividerTableViewCell else { return UITableViewCell() }
            dividerCell.selectionStyle = .none
            return dividerCell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
            //case SectionType.PROFILE_CELL.rawValue:
            
            //case SectionType.ROLE_CELL.rawValue:
            
        case SectionType.ICON_ITEM_CELL.rawValue:
            if iconItems[indexPath.row].text == "Settings" {
                self.performSegue(withIdentifier: "showSettingSegue", sender: self.tableView)
            } else if iconItems[indexPath.row].text == "Sign out" {
                onSignout(tableView.cellForRow(at: indexPath))
            }
            break
        case SectionType.ONLY_TEXT_CELL.rawValue:
            if textItems[indexPath.row].text == NSLocalizedString("settings_term_conditions", tableName: "Vector", bundle: Bundle.main, value: "", comment: "") {
                let webViewViewController: WebViewViewController = WebViewViewController(url: BuildSettings.applicationTermsConditionsUrlString)
                webViewViewController.title = NSLocalizedString("settings_term_conditions", tableName: "Vector", bundle: Bundle.main, value: "", comment: "")
                navigationController?.pushViewController(webViewViewController, animated: true)
            } else if textItems[indexPath.row].text == NSLocalizedString("settings_privacy_policy", tableName: "Vector", bundle: Bundle.main, value: "", comment: "") {
                let webViewViewController: WebViewViewController = WebViewViewController(url: BuildSettings.applicationPrivacyPolicyUrlString)
                webViewViewController.title = NSLocalizedString("settings_privacy_policy", tableName: "Vector", bundle: Bundle.main, value: "", comment: "")
                navigationController?.pushViewController(webViewViewController, animated: true)
            }
            break
        default:
            break
        }
    }
}


extension ProfileViewController: SignOutAlertPresenterDelegate {
    func onSignout(_ sender: Any?) {
        let cell = sender as? UITableViewCell
        let keyBackup = mainSession.crypto.backup
        signOutAlertPresenter.present(for: keyBackup?.state ?? MXKeyBackupStateUnknown, areThereKeysToBackup: keyBackup?.hasKeysToBackup ?? false, from: self, sourceView: cell, animated: true)
    }
    
    func signOutAlertPresenterDidTapSignOutAction(_ presenter: SignOutAlertPresenter) {
        // Prevent user to perform user interaction in settings when sign out
        view.isUserInteractionEnabled = false
        startActivityIndicator()
        //MXWeakify(self)
        AppDelegate.the().logout(withConfirmation: false) { isLoggedOut in
            //MXStrongifyAndReturnIfNil(self)
            self.stopActivityIndicator()
            self.view.isUserInteractionEnabled = true
        }
    }
    
    func signOutAlertPresenterDidTapBackupAction(_ presenter: SignOutAlertPresenter) {
        print("not implemented")
    }
}
