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

class FilteredSearchPopoverViewController<T>: UIViewController where T: Equatable {
    @IBOutlet weak var FilteredSearchViewControllerContainer: UIView!
    @IBOutlet weak var attachedSearchBar: UISearchBar!
    var selectingViewController: FilteredSearchResultsController<T>!
    var onSelectedCallback: ((T) -> Void)?
    
    func SetSearchBarPlaceholder(to placeholder: String){
        attachedSearchBar.placeholder = placeholder
    }
    
    init(withScrollHandler scrollHandler: (() -> Void)?, andViewCellReuseID cellReuseID: String, andService service: AsyncQueryableService<T>) {
        super.init(nibName: "FilteredSearchPopoverViewController", bundle: nil)
        selectingViewController = FilteredSearchResultsController<T>(withSelectionChangeHandler: { (Selected, _) in
            self.dismiss(animated: true) {
                if let callback = self.onSelectedCallback {
                    callback(Selected)
                }
            }
        }, andScrollHandler: scrollHandler ?? {}, andReuseIdentifier: cellReuseID, andConnectedService: service)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    static func nib() -> UINib! {
        UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
    override func viewWillAppear(_ animated: Bool) {
        view.backgroundColor = ThemeService.shared().theme.backgroundColor
        selectingViewController.mode = .Single
        
        FilteredSearchViewControllerContainer.subviews.forEach({(x) in x.removeFromSuperview()})
        FilteredSearchViewControllerContainer.layoutIfNeeded()
        
        FilteredSearchViewControllerContainer.addSubview(selectingViewController.view)
        selectingViewController.view.translatesAutoresizingMaskIntoConstraints = false
        FilteredSearchViewControllerContainer.addConstraints([
            NSLayoutConstraint(item: selectingViewController.view as Any, attribute: .left, relatedBy: .equal, toItem: FilteredSearchViewControllerContainer, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: selectingViewController.view as Any, attribute: .right, relatedBy: .equal, toItem: FilteredSearchViewControllerContainer, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: selectingViewController.view as Any, attribute: .top, relatedBy: .equal, toItem: FilteredSearchViewControllerContainer, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: selectingViewController.view as Any, attribute: .bottom, relatedBy: .equal, toItem: FilteredSearchViewControllerContainer, attribute: .bottom, multiplier: 1, constant: 0)
        ])
        ThemeService.shared().theme.applyStyle(onSearchBar: attachedSearchBar)
    }
    
    override func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        selectingViewController.applyFilter(searchText)
    }
}
