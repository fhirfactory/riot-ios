//
//  ActPeopleViewController.swift
//  Riot
//
//  Created by Naurin Afrin on 31/7/20.
//  Copyright © 2020 matrix.org. All rights reserved.
//

import UIKit

class ActPeopleViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var attachedSearchBar: UISearchBar!
    @IBOutlet weak var FavouritesButton: UIButton!
    
    var people: [ActPeopleModel] = []
    var favourites: [ActPeopleModel] {
        get {
            people.filter { (m) -> Bool in
                m.Favourite
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabItem.title = AlternateHomeTools.getNSLocalized("people_title", in: "Vector")
        setupTableView()
        ThemeService.shared().theme.recursiveApply(on: self.view)
        attachedSearchBar.searchBarStyle = .minimal
        
        //attachedSearchBar.barTintColor = ThemeService.shared().theme.backgroundColor
        //attachedSearchBar.backgroundColor = ThemeService.shared().theme.tintColor
        
        //TODO: Remove when there's a real data source
        people = []
        let session = (AppDelegate.theDelegate().mxSessions.first as? MXSession)
        for i in 1...10 {
            
            let person = ActPeopleModel(withBaseUser: ((AppDelegate.theDelegate().mxSessions.first as? MXSession)?.user(withUserId: session?.myUserId))!, officialName: "Person \(i)", jobTitle: "App Developer", org: "ACT Health", businessUnit: "I dunno")
            person.emailAddress = "email@email.com"
            person.phoneNumber = "0412345678"
            people.append(person)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadSections(IndexSet(integer: 0), with: .none)
    }
    
    var showingFavourites: Bool = false
    @IBAction func FavouritesToggled(_ sender: Any) {
        showingFavourites = !showingFavourites
        if #available(iOS 13.0, *) {
            FavouritesButton.setImage(UIImage(systemName: (showingFavourites ? "star.fill" : "star")), for: .normal)
        } else {
            // Fallback on earlier versions
        }
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if attachedSearchBar.isFirstResponder {
            attachedSearchBar.resignFirstResponder()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if attachedSearchBar.isFirstResponder {
            attachedSearchBar.resignFirstResponder()
        }
    }
}


// MARK: Private functions
extension ActPeopleViewController {
    private func setupTableView() {
        tableView.delegate = self
        tableView.delaysContentTouches = false
        tableView.dataSource = self
        tableView.allowsSelection = true
        tableView.estimatedRowHeight = 500
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "PeopleTableViewCell", bundle: nil), forCellReuseIdentifier: "PeopleTableViewCell")
        tableView.register(UINib(nibName: "NoFavouritesTableViewCell", bundle: nil), forCellReuseIdentifier: "NoFavouritesTableViewCell")
    }
}


// MARK: UITableViewDataSource
extension ActPeopleViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showingFavourites {
            return favourites.count == 0 ? 1 : favourites.count
        }
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if showingFavourites && favourites.count == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoFavouritesTableViewCell") as? NoFavouritesTableViewCell else { return UITableViewCell() }
            cell.SetItem(to: AlternateHomeTools.getNSLocalized("people_title", in: "Vector"))
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleTableViewCell") as? PeopleTableViewCell else { return UITableViewCell() }
        
        
        // TODO:- This needs to be replaced with appropriate code once the backend is available and can provide role information to the app
        cell.setValue(actPeople: showingFavourites ? favourites[indexPath.row] : people[indexPath.row])
        cell.peopleCellDelegate = self
        
        let selectedView = UIView()
        selectedView.backgroundColor = ThemeService.shared().theme.selectedBackgroundColor
        
        cell.selectedBackgroundView = selectedView
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let vc = PeopleDetailViewController() //your view controller
        //vc.actPeople = people[indexPath.row]
        guard let cell = self.tableView(tableView, cellForRowAt: indexPath) as? PeopleTableViewCell else { return }
        guard let person = cell.actPeopleModel else { return }
        vc.setPerson(person: person)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ActPeopleViewController: FavouriteActionReceiverDelegate {
    func FavouritesUpdated(favourited: Bool) {
        if showingFavourites && !favourited {
            tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
    }
}

extension ActPeopleViewController {
    override func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
