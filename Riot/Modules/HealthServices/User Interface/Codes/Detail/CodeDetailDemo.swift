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
class CodeDetailDemo: UITableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4
        case 1:
            return 7
        case 2:
            return 2
        default:
            break
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.backgroundColor = ThemeService.shared().theme.headerBackgroundColor
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "Responders"
        case 2:
            return "Other"
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                return tableView.dequeueReusableCell(withIdentifier: "CodeDetailTopCell", for: indexPath)
            }
            
            let buttoncell = MXKTableViewCellWithButton()
            switch indexPath.row {
            case 1:
                buttoncell.mxkButton.setTitle("Accept", for: .normal)
            case 2:
                buttoncell.mxkButton.setTitle("Decline", for: .normal)
            case 3:
                buttoncell.mxkButton.tintColor = .systemRed
                buttoncell.mxkButton.setTitle("Stand Down", for: .normal)
            default:
                break
            }
            return buttoncell
        case 1:
            if indexPath.row < 6 {
                return tableView.dequeueReusableCell(withIdentifier: "ResponderCell", for: indexPath)
            } else {
                let buttoncell = MXKTableViewCellWithButton()
                buttoncell.mxkButton.setTitle("View Responder Timeline", for: .normal)
                return buttoncell
            }
        case 2:
            switch indexPath.row {
            case 0:
                let buttoncell = MXKTableViewCellWithButton()
                buttoncell.mxkButton.setTitle("View Notifiers", for: .normal)
                return buttoncell
            case 1:
                let buttoncell = MXKTableViewCellWithButton()
                buttoncell.mxkButton.setTitle("View Joiners", for: .normal)
                return buttoncell
            default:
                break
            }
        default:
            break
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 6 {
            let timelineView = ResponderTimeline()
            self.present(timelineView, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        tableView.register(UINib(nibName: "CodeDetailTopCell", bundle: nil), forCellReuseIdentifier: "CodeDetailTopCell")
        tableView.register(UINib(nibName: "ResponderCell", bundle: nil), forCellReuseIdentifier: "ResponderCell")
    }
}
