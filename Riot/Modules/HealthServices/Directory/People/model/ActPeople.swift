//
//  ActPeople.swift
//  Riot
//
//  Created by Naurin Afrin on 3/8/20.
//  Copyright © 2020 matrix.org. All rights reserved.
//

import Foundation

class ActPeopleModel: Practitioner, Equatable {
    static func == (lhs: ActPeopleModel, rhs: ActPeopleModel) -> Bool {
        lhs.ID == rhs.ID && lhs.matrixID == rhs.matrixID && lhs.name == rhs.name
    }
    
    
    var innerPractitioner: Practitioner
    
    var name: String {
        return innerPractitioner.name
    }
    
    func GetRoles(callback: ([PractitionerRole]) -> Void) {
        
    }
    
    var jobTitle: String {
        return innerPractitioner.jobTitle
    }
    
    var businessUnit: String {
        return innerPractitioner.businessUnit
    }
    
    var ID: String {
        return innerPractitioner.ID
    }
    
    var phoneNumber: String? {
        return innerPractitioner.phoneNumber
    }
    
    var emailAddress: String? {
        return innerPractitioner.emailAddress
    }
    
    var onlineStatus: Bool {
        return innerPractitioner.onlineStatus
    }
    
    var activeStatus: Bool {
        return innerPractitioner.activeStatus
    }
    
    var matrixID: String {
        return innerPractitioner.matrixID
    }
    
    var organisation: String {
        return innerPractitioner.organisation
    }
    
    var displayName: String {
        innerPractitioner.displayName
    }
    
    var avatarURL: String?
    
    private var _favourite = false
    var isExpanded: Bool = false
    //Update some database or something when this changes
    var Favourite: Bool {
        get {
            return _favourite
        }
        set(value) {
            _favourite = value
        }
    }
    
    init(innerPractitioner: Practitioner) {
        self.innerPractitioner = innerPractitioner
    }
}
