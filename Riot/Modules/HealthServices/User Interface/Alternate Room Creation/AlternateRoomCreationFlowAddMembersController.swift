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

class AlternateRoomCreationParameters {
    var publicRoom: Bool = false
    var topic: String?
    var name: String?
    var showInDirectory: Bool = false
    var roomAddress: String?
    var roomAvatar: UIImage?
    var fallbackAvatar: UIImage?
}

class AlternateRoomCreationFlowAddMembersController: UIViewController, UICollectionViewDataSource {
    @IBOutlet weak var SearchResultContainerView: UIView!
    @IBOutlet var SearchControllerTopConstraint: NSLayoutConstraint!
    var SearchControllerSelectedShowingConstraint: NSLayoutConstraint!
    @IBOutlet weak var CollectionView: UICollectionView!
    
    @IBOutlet weak var SearchBar: UISearchBar!
    @IBAction private func SearchResultAreaTapped(_ sender: Any) {
        dismissKeyboard()
    }
    //While this should really be an array of equatable, here we have to use Any, because Swift doesn't let you use Equatable
    var selectedItems: [Any] = []
    
    var currentTheme: Theme!
    
    var roomParameters: AlternateRoomCreationParameters = AlternateRoomCreationParameters()
    
    static func nib() -> UINib! {
        UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
    var filteredSearchViewControllers: [FilteredTableViewSource]!
    var selectionChangedComplete: (() -> Void)?
    
    func selectionChangedHandler(item: Any, added: Bool) {
        if added {
            selectedItems.append(item)
        } else {
            selectedItems.removeAll(where: {(theItem) in
                return (theItem is ActPeople && item is ActPeople) && (theItem as? ActPeople == item as? ActPeople)
            })
        }
        CollectionView.reloadData()
        animateResultViewIfNeeded()
        if let completionHandler = selectionChangedComplete {
            completionHandler()
        }
    }
    
    @objc func nextButtonWasPressed() {
        let nextStageViewController = AlternateRoomCreationFlowDetails()
        nextStageViewController.Setup(self, parameters: roomParameters)
        self.navigationController?.show(nextStageViewController, sender: self)
    }
    
    func drawButton() {
        //https://stackoverflow.com/questions/50364760/navigation-bar-item-not-clickable-when-uitextview-resigns-first-responder
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: AlternateHomeTools.getNSLocalized("next", in: "Vector"), style: .plain, target: self, action: #selector(nextButtonWasPressed))
        self.navigationItem.rightBarButtonItem?.isEnabled = selectedItems.count > 0
    }
    
    override func viewDidLoad() {
        drawButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if filteredSearchViewControllers == nil || filteredSearchViewControllers.count == 0 {
            filteredSearchViewControllers = [RoleFilteredSearchController(), PeopleFilteredSearchController(withSelectionChangeHandler: selectionChangedHandler(item:added:), andScrollHandler: dismissKeyboard)]
            
            self.navigationItem.title = AlternateHomeTools.getNSLocalized("room_creation_add_members", in: "Vector")
            
            let search = SearchViewSection()
            search.initWithTitles([AlternateHomeTools.getNSLocalized("roles_title", in: "Vector"), AlternateHomeTools.getNSLocalized("people_title", in: "Vector")], viewControllers: filteredSearchViewControllers, defaultSelected: 0)
            search.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: search.view.frame.height)
            
            SearchResultContainerView.addSubview(search.view)
            
            search.view.translatesAutoresizingMaskIntoConstraints = false
            SearchResultContainerView.addConstraints(
                [
                    NSLayoutConstraint(item: search.view as Any, attribute: .left, relatedBy: .equal, toItem: SearchResultContainerView, attribute: .left, multiplier: 1, constant: 0),
                    NSLayoutConstraint(item: search.view as Any, attribute: .right, relatedBy: .equal, toItem: SearchResultContainerView, attribute: .right, multiplier: 1, constant: 0),
                    NSLayoutConstraint(item: search.view as Any, attribute: .top, relatedBy: .equal, toItem: SearchResultContainerView, attribute: .top, multiplier: 1, constant: 0),
                    NSLayoutConstraint(item: search.view as Any, attribute: .bottom, relatedBy: .equal, toItem: SearchResultContainerView, attribute: .bottom, multiplier: 1, constant: 0)
            ])
            
            CollectionView.register(UINib(nibName: String(describing: RoomCreationCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: RoomCreationCollectionViewCell.self))
            
            currentTheme = ThemeService.shared().theme
            if BuildSettings.settingsScreenOverrideDefaultThemeSelection != "" {
                currentTheme = ThemeService.shared().theme(withThemeId: BuildSettings.settingsScreenOverrideDefaultThemeSelection as String)
            }
            
            view.backgroundColor = currentTheme.backgroundColor
            CollectionView.backgroundColor = currentTheme.backgroundColor
            currentTheme.applyStyle(onSearchBar: SearchBar)
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedItems.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let val: Any = selectedItems[indexPath.row]
        switch val {
        case let v as ActPeople:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: RoomCreationCollectionViewCell.self), for: indexPath) as? RoomCreationCollectionViewCell else {return UICollectionViewCell()}
            cell.renderWithAndProvideCanceller(renderer: RoomCreationCollectionViewPeopleCellRenderer.GetRendererFor(v), cancelButtonHander: {() in
                self.selectionChangedHandler(item: v, added: false)
                guard let searchController = self.filteredSearchViewControllers[1] as? PeopleFilteredSearchController else { return }
                searchController.deselect(Item: v)
                
            })
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
        self.drawButton()
    }
    
    override func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
    }
    
    override func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            if #available(iOS 13.0, *) {
                searchBar.searchTextField.textColor = currentTheme.textPrimaryColor
            } else {
                searchBar.vc_searchTextField?.textColor = currentTheme.textPrimaryColor
            }
        } else {
            if #available(iOS 13.0, *) {
                searchBar.searchTextField.textColor = currentTheme.placeholderTextColor
            } else {
                searchBar.vc_searchTextField?.textColor = currentTheme.placeholderTextColor
            }
        }
        for x in filteredSearchViewControllers {
            x.applyFilter(searchText)
        }
    }
    
    var selectedCount = 0
    func animateResultViewIfNeeded() {
        if selectedItems.count != selectedCount {
            if selectedItems.count * selectedCount > 0 {
                //if neither selectedItems nor selectedCount are 0, just change the selectedCount
                //don't do anything here (as the selectedCount is updated elsewhere)
            } else {
                // if going from 0 to something else, animate to show selection area, by disabling the strong constraint on the top of the search result area
                // if going from something else to 0, animate to hide selection area
                view.layoutIfNeeded()
                
                SearchControllerTopConstraint.isActive = (selectedItems.count <= 0)
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.layoutIfNeeded()
                })
                self.drawButton()
            }
            selectedCount = selectedItems.count
        }
    }
}
