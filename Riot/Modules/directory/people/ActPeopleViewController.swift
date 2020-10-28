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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabItem.title = NSLocalizedString("people_title", tableName: "Act", comment: "")
        setupTableView()
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
    }
}


// MARK: UITableViewDataSource
extension ActPeopleViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleTableViewCell") as? PeopleTableViewCell else { return UITableViewCell() }
        
        let session = (AppDelegate.theDelegate().mxSessions.first as? MXSession)
        var person = ActPeople(withBaseUser: ((AppDelegate.theDelegate().mxSessions.first as? MXSession)?.user(withUserId: session?.myUserId))!, officialName: "Joseph Fergusson", jobTitle: "App Developer", org: "ACT Health", businessUnit: "I dunno")
        person.emailAddress = "email@email.com"
        person.phoneNumber = "0412345678"
        cell.setValue(actPeople: person)
        cell.peopleCellDelegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let vc = PeopleDetailViewController() //your view controller
        //vc.actPeople = people[indexPath.row]
        guard let cell = self.tableView(tableView, cellForRowAt: indexPath) as? PeopleTableViewCell else { return }
        guard let person = cell.actPeople else { return }
        vc.setPerson(person: person)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ActPeopleViewController: PeopleCellDelegate {
    func favoriteButtonClick(actPeople: ActPeople?) {
        // need implementation
    }
}
