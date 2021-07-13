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

enum SelectionMode {
    case Single
    case Multiple
    case Directory
}

class SelectableFilteredSearchController<T: Equatable>: UIViewController, FilteredTableViewSource, UITableViewDelegate, UITableViewDataSource {
    
    final func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    
    @IBOutlet weak var FavouritesButton: UIButton?
    @IBOutlet weak var SearchBar: UISearchBar?
    @IBOutlet weak var tableView: UITableView!
    
    var selected: [T] = []
    internal var selectionDidChange: ((_ item: T, _ added: Bool) -> Void)
    private var scrollViewDidScroll: (() -> Void)?
    let session: MXSession
    var mode: SelectionMode = .Multiple
    private var favouritesToggled = false
    var items: [T] = []
    let pageSize = 10
    var page = 0
    
    @IBAction private func FavouritesToggled(_ sender: Any) {
        favouritesToggled = !favouritesToggled
        reloadPages()
        getPage()
        setFavouritesIcon()
    }
    
    override init(nibName: String?, bundle: Bundle?) {
        selectionDidChange = {(_,_) in
            
        }
        session = (AppDelegate.theDelegate().mxSessions.first as? MXSession)!
        super.init(nibName: nibName, bundle: bundle)
    }
    
    init (withSelectionChangeHandler selectionChanged: @escaping ((_ item: T, _ added: Bool) -> Void), andScrollHandler scrollViewDidScroll: @escaping (() -> Void), nibName: String? = nil, bundle: Bundle? = nil) {
        selectionDidChange = selectionChanged
        session = (AppDelegate.theDelegate().mxSessions.first as? MXSession)!
        self.scrollViewDidScroll = scrollViewDidScroll
        if let name = nibName {
            super.init(nibName: name, bundle: bundle)
        } else {
            super.init()
        }
    }
    
    convenience init() {
        self.init(withSelectionChangeHandler: {(_, _) in
            
        }, andScrollHandler: {})
        mode = .Directory
    }
    
    required init?(coder: NSCoder) {
        selectionDidChange = {(_, _) in
            
        }
        session = (AppDelegate.theDelegate().mxSessions.first as? MXSession)!
        super.init(coder: coder)
    }
    
    static func nib() -> UINib! {
        UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
    
    func getReuseIdentifier() -> String {
        preconditionFailure("Override")
    }
    
    func registerReuseIdentifierForTableView(_ tableView: UITableView) {
        tableView.register(getNib(), forCellReuseIdentifier: getReuseIdentifier())
    }
    
    func setFavouritesIcon() {
        if #available(iOS 13.0, *) {
            FavouritesButton?.setImage(UIImage(systemName: (favouritesToggled ? "star.fill" : "star")), for: .normal)
        }
    }
    
    var currentTheme: Theme!
    
    override func viewDidLoad() {
        
        tableView.delegate = self
        tableView.dataSource = self
        registerReuseIdentifierForTableView(tableView)
        
        currentTheme = ThemeService.shared().theme
        if BuildSettings.settingsScreenOverrideDefaultThemeSelection != "" {
            currentTheme = ThemeService.shared().theme(withThemeId: BuildSettings.settingsScreenOverrideDefaultThemeSelection as String)
            currentTheme.recursiveApply(on: self.view)
        }
        
        tableView.tintColor = currentTheme.textPrimaryColor
        tableView.backgroundColor = currentTheme.backgroundColor
        
        SearchBar?.delegate = self
        setFavouritesIcon()
        
        getPage()
    }
    
    override func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    var currentFilter: String?
    final func applyFilter(_ filter: String?) {
        if currentFilter != filter {
            currentFilter = filter
            reloadPages()
            getPage()
        }
    }
    
    private var debouncer: Debouncer<String?>!
    func changeFilter(_ filter: String?) {
        if debouncer == nil {
            debouncer = Debouncer<String?>(callback: applyFilter(_:))
        }
        if filter != "" {
            debouncer.TrySetValue(value: filter)
            return
        }
        debouncer.TrySetValue(value: nil)
    }
    override func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        changeFilter(searchText)
    }
    
    
    
    final func reloadPages() {
        
        page = 0
        requestCounter -= 10
        tableView.beginUpdates()
        items = []
        tableView.reloadSections(IndexSet(integer: 0), with: .none)
        tableView.endUpdates()
    }
    
    private var requestCounter: Int = 0
    final func getPage() {
        paginate(page: page, pageSize: pageSize, filter: currentFilter, favourites: favouritesToggled, addPage: getAddPage(request: requestCounter))
    }
    
    final func getNextPage() {
        page += 1
        getPage()
    }
    
    func getAddPage(request: Int) -> ([T]) -> Void {
        return { list in
            if self.requestCounter >= request {
                self.addPage(itm: list)
            }
        }
    }
    
    func addPage(itm: [T]) {
        let count = items.count
        items.append(contentsOf: itm)
        tableView.beginUpdates()
        let rowsToInsert = (0..<itm.count).map { index in
            IndexPath(row: count + index, section: 0)
        }
        tableView.insertRows(at: rowsToInsert, with: .automatic)
        tableView.endUpdates()
        
    }
    
    func paginate(page: Int, pageSize: Int, filter: String?, favourites: Bool, addPage: @escaping ([T]) -> Void) {
        preconditionFailure("paginate must be overridden")
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let cell = self.tableView(tableView, cellForRowAt: indexPath)
        guard let val = getUnderlyingValue(cell) ?? (items.count > indexPath.row ? items[indexPath.row] : nil) else { return nil }
        if !selected.contains(where: {(x) in
            return x == val
        }) {
            if self.mode == .Multiple {
                selected.append(val)
                selectionDidChange(val, true)
            } else if self.mode == .Single {
                selected = [val]
                selectionDidChange(val, true)
            } else if self.mode == .Directory {
                return indexPath
            }
        } else {
            selected.removeAll(where: {(x) in
                return x == val
            })
            selectionDidChange(val, false)
        }
        tableView.reloadRows(at: [indexPath], with: .fade)
        return nil
    }
    
    func getTableviewCell(_ tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        preconditionFailure("must be overridden")
    }
    
    func selectedItem(item: T) {
        preconditionFailure("must be overridden")
    }
    
    func getNib() -> UINib {
        preconditionFailure("must be overridden")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if mode == .Directory {
            selectedItem(item: items[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = currentTheme.headerBackgroundColor
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = currentTheme.headerTextPrimaryColor
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        SearchBar?.resignFirstResponder()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewDidScroll?()
    }
    
    func getUnderlyingValue(_ tableViewCell: UITableViewCell) -> T? {
        nil
    }
    
    func deselect(Item theItem: T) {
        selected.removeAll(where: {(x) in
            x == theItem
        })
        if let refreshLocation = getIndexPathFor(Item: theItem) {
            tableView.reloadRows(at: [refreshLocation], with: .fade)
        }
    }
    
    func getIndexPathFor(Item theItem: T) -> IndexPath? {
        preconditionFailure("Override in deriving class.")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row > (page - 1) * pageSize {
            getNextPage()
        }
        if indexPath.row >= items.count {
            return UITableViewCell()
        }
        let cell = getTableviewCell(tableView, atIndexPath: indexPath)
        let data = getUnderlyingValue(cell) ?? items[indexPath.row]
        if selected.contains(where: {(e) in
            e == data
        }) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        cell.selectedBackgroundView = UIView()
        cell.selectedBackgroundView?.backgroundColor = currentTheme.selectedBackgroundColor
        return cell
    }
}


class ExtendedSelectableFilteredSearchController<T: Equatable, U: UITableViewCell>: SelectableFilteredSearchController<T> {
    func bindContentToCell(cell: U, data: T, index: Int) {
        preconditionFailure("must be overridden")
    }
    
    override func getTableviewCell(_ tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: getReuseIdentifier(), for: indexPath) as? U else { return UITableViewCell() }
        bindContentToCell(cell: cell, data: items[indexPath.row], index: indexPath.row)
        return cell
    }
}

class SimpleSelectableFilteredSearchController<T,U>: ExtendedSelectableFilteredSearchController<U,T> where T: BaseGenericDirectoryCell<U>, T: ProvidesReuseIdentifierAndNib, U: Equatable {
    override func getNib() -> UINib {
        T.getNib()
    }
    override func getReuseIdentifier() -> String {
        T.getReuseIdentifier()
    }
    override func bindContentToCell(cell: T, data: U, index: Int) {
        cell.bind(data: data, index: index)
    }
}
