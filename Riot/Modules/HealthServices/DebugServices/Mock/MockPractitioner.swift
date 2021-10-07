//
//  MockPractitioner.swift
//  Riot
//
//  Created by Joseph Fergusson on 12/7/21.
//  Copyright © 2021 matrix.org. All rights reserved.
//

import Foundation

class MockPractitioner: Practitioner {
    var name: String
    
    func GetRoles(callback: ([PractitionerRole]) -> Void) {
        
    }
    
    var jobTitle: String {
        "Sample Job Title"
    }
    
    var businessUnit: String {
        "Sample Business Unit"
    }
    
    var organisation: String {
        "Sample Organization"
    }
    
    var ID: String
    
    var phoneNumber: String? {
        "0449079058"
    }
    
    var emailAddress: String? {
        "firstname.lastname@act.gov.au"
    }
    
    var onlineStatus: Bool {
        false
    }
    
    var activeStatus: Bool {
        false
    }
    
    var matrixID: String {
        "matrix-id@chs.act.gov.au"
    }
    
    var avatarURL: String? {
        nil
    }
    
    var displayName: String {
        name
    }
    
    init(name: String) {
        self.name = name
        self.ID = name
    }
    
}
