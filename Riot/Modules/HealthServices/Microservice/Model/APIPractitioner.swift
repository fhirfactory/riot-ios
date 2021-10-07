//
//  APIPractitioner.swift
//  Riot
//
//  Created by Joseph Fergusson on 19/7/21.
//  Copyright © 2021 matrix.org. All rights reserved.
//

import Foundation

class APIPractitioner: Practitioner, Codable {
    var displayName: String {
        name
    }
    
    var name: String {
        innerPractitioner.displayName
    }
    
    func GetRoles(callback: ([PractitionerRole]) -> Void) {
        
    }
    
    var jobTitle: String {
        innerPractitioner.mainJobTitle ?? ""
    }
    
    var businessUnit: String {
        if innerPractitioner.organisationStructure.count > 4 {
            return innerPractitioner.organisationStructure[4].value
        }
        return ""
    }
    
    var organisation: String {
        if innerPractitioner.organisationStructure.count > 4 {
            return innerPractitioner.organisationStructure[1].value
        }
        return ""
    }
    
    var ID: String {
        innerPractitioner.simplifiedID
    }
    
    var phoneNumber: String? {
        innerPractitioner.contactPoints.first { contact in
            contact.type.uppercased() == "MOBILE"
        }?.value
    }
    
    var emailAddress: String? {
        innerPractitioner.contactPoints.first { contact in
            contact.type.uppercased() == "EMAILADDRESS"
        }?.value
    }
    
    var onlineStatus: Bool {
        innerPractitioner.practitionerStatus.loggedIn
    }
    
    var activeStatus: Bool {
        innerPractitioner.practitionerStatus.active
    }
    
    var matrixID: String {
        innerPractitioner.matrixId
    }
    
    var avatarURL: String?
    
    var innerPractitioner: FHIRPractitioner
    init(fhirPractitioner: FHIRPractitioner) {
        innerPractitioner = fhirPractitioner
    }
}
