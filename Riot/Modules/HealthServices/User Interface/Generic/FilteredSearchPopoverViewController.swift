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

class FilteredSearchPopoverViewController<Service: DataQueryService>: FilteredSearchResultsController<Service, Service.ReturnType> where Service.ReturnType: Equatable {
    typealias T = Service.ReturnType
    var onSelected: ((T) -> Void)?
    
    func SetSearchBarPlaceholder(to placeholder: String){
        SearchBar?.placeholder = placeholder
    }
    
    init(withScrollHandler scrollHandler: (() -> Void)?, andViewCellReuseID cellReuseID: String, andService service: Service) {
        super.init(nibName: "FilteredSearchPopoverViewController", bundle: nil)
        super.initializeService(With: service, AndReuseIdentifier: cellReuseID)
        selectionDidChange = { Selected, _ in
            self.dismiss(animated: true) {
                if let callback = self.onSelected {
                    callback(Selected)
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.backgroundColor = ThemeService.shared().theme.backgroundColor
        self.mode = .Single
        if let search = SearchBar {
            ThemeService.shared().theme.applyStyle(onSearchBar: search)
        }
        
        super.viewWillAppear(animated)
    }
}
