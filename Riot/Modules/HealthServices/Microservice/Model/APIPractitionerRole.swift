//
//  APIPractitionerRole.swift
//  Riot
//
//  Created by Joseph Fergusson on 19/7/21.
//  Copyright © 2021 matrix.org. All rights reserved.
//

import Foundation

class APIPractitionerRole: PractitionerRole {
    var longName: String {
        innerPractitionerRole.identifiers.first { identifier in
            identifier.type == "LongName"
        }?.value ?? displayName
    }
    
    var shortName: String {
        innerPractitionerRole.displayName
    }
    
    var orgName: String {
        innerPractitionerRole.primaryOrganizationID
    }
    
    var roleName: String {
        innerPractitionerRole.primaryRoleID
    }
    
    var roleCategory: String {
        innerPractitionerRole.primaryRoleCategoryID
    }
    
    var location: String {
        innerPractitionerRole.primaryLocationID
    }
    
    func GetPractitioners(callback: ([Practitioner]) -> Void) {
        
    }
    
    var ID: String {
        innerPractitionerRole.simplifiedID
    }
    
    var active: Bool {
        innerPractitionerRole.activePractitionerSet.count > 0
    }
    
    var matrixID: String {
        "nothing here"
    }
    
    var avatarURL: String?
    
    var innerPractitionerRole: FHIRPractitionerRole!
    init(innerPractitionerRole: FHIRPractitionerRole) {
        self.innerPractitionerRole = innerPractitionerRole
    }
}
