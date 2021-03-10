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
class ResponderGroup {
    let Name: String
    var Responders: [String]
    let RequiredCount: Int
    var Expanded: Bool
    init(Name:String,Responders:[String],Expanded:Bool,RequiredCount:Int) {
        self.Name = Name
        self.Responders = Responders
        self.Expanded = Expanded
        self.RequiredCount = RequiredCount
    }
}
class AlternateCodeDetailDemo: UITableViewController, ChecklistItemDelegate {
    
    let responderGroups = [ResponderGroup(Name:"Met Nurse",Responders:["Alex Somebody", "Mary O'Donnovan", "John Silva"],Expanded:false,RequiredCount:4),ResponderGroup(Name:"Doctor on Call",Responders:["Jane Appleseed"],Expanded:false,RequiredCount:2)]
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func responderSectionCount() -> Int {
        var count = 0
        for responderGroup in responderGroups {
            count += (responderGroup.Expanded ? responderGroup.Responders.count + 1 : 1)
        }
        return count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return responderSectionCount() + 1
        case 2:
            return 2
        default:
            break
        }
        return 0
    }
    
    func didExpandChecklistItem(index: Int) {
        responderGroups[index].Expanded = !responderGroups[index].Expanded
        tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.backgroundColor = ThemeService.shared().theme.headerBackgroundColor
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "Checklist"
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
                buttoncell.mxkButton.tintColor = .systemRed
                buttoncell.mxkButton.setTitle("Decline", for: .normal)
            default:
                break
            }
            return buttoncell
        case 1:
            if indexPath.row < responderSectionCount() {
                var idx = 0
                var groupidx = 0
                var responderidx = -1
                while idx < indexPath.row {
                    if responderGroups[groupidx].Expanded == false {
                        groupidx += 1
                        responderidx = -1
                        idx += 1
                    } else {
                        idx += 1
                        responderidx += 1
                        if responderidx >= responderGroups[groupidx].Responders.count {
                            responderidx = -1
                            groupidx += 1
                        }
                    }
                }
                if responderidx == -1 {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItemCell", for: indexPath) as? ChecklistItemCell else { return UITableViewCell() }
                    cell.delegate = self
                    cell.Index = groupidx
                    cell.SetResponderGroup(Group: responderGroups[groupidx])
                    return cell
                } else {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResponderCell", for: indexPath) as? ResponderCell else { return UITableViewCell() }
                    cell.SetRoleText(responderGroups[groupidx].Name)
                    cell.SetName(responderGroups[groupidx].Responders[responderidx])
                    cell.contentView.backgroundColor = ThemeService.shared().theme.tintBackgroundColor
                    return cell
                }
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
        if indexPath.section == 0 && indexPath.row == 1 {
            let alertController = UIAlertController(title: "Critical Event", message: "Join Response Team?", preferredStyle: .actionSheet)
            for group in responderGroups {
                alertController.addAction(UIAlertAction(title: "Accept as \(group.Name)", style: .default, handler: { (_) in
                    group.Responders.append("Joseph Fergusson")
                    tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
                }))
            }
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        
        if indexPath.section == 1 && indexPath.row >= responderSectionCount() {
            let timelineView = ResponderTimeline()
            self.present(timelineView, animated: true, completion: nil)
            return
        }
        
        if let cell = self.tableView(tableView, cellForRowAt: indexPath) as? ChecklistItemCell {
            guard let rolename = cell.RoleName else { return }
            let alertActionAccept = UIAlertAction(title: "Accept as \(rolename)", style: .default) { (_) in
                cell.ResponderGroup.Responders.append("Joseph Fergusson")
                tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
            }
            let alertActionDecline = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let alertController = UIAlertController(title: "Critical Event", message: "Join Response Team?", preferredStyle: .actionSheet)
            alertController.addAction(alertActionAccept)
            alertController.addAction(alertActionDecline)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        tableView.register(UINib(nibName: "CodeDetailTopCell", bundle: nil), forCellReuseIdentifier: "CodeDetailTopCell")
        tableView.register(UINib(nibName: "ResponderCell", bundle: nil), forCellReuseIdentifier: "ResponderCell")
        tableView.register(UINib(nibName: "ChecklistItemCell", bundle: nil), forCellReuseIdentifier: "ChecklistItemCell")
        if #available(iOS 14.0, *) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: nil, image: UIImage(systemName: "ellipsis.circle.fill"), primaryAction: nil, menu: UIMenu(title: "More", image: nil, identifier: nil, options: .destructive, children: [UIAction(title: "Stand Down", image: nil, identifier: nil, discoverabilityTitle: nil, attributes: .destructive, state: .off, handler: {(_) in
                
            })]))
        }
    }
    
    func something(){
        
    }
}


protocol ChecklistItemDelegate {
    func didExpandChecklistItem(index: Int)
}
