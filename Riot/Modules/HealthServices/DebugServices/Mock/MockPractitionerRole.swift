//
//  MockPractitionerRole.swift
//  Riot
//
//  Created by Joseph Fergusson on 12/7/21.
//  Copyright © 2021 matrix.org. All rights reserved.
//

import Foundation
class MockPractitionerRole: PractitionerRole {
    var longName: String
    
    var shortName: String {
        longName
    }
    
    var orgName: String {
        "Org Name"
    }
    
    var roleName: String {
        "Role Name"
    }
    
    var roleCategory: String {
        "Role Category"
    }
    
    var location: String {
        "Canberra Hospital"
    }
    
    func GetPractitioners(callback: ([Practitioner]) -> Void) {
        
    }
    
    var ID: String {
        longName
    }
    
    var active: Bool {
        false
    }
    
    var matrixID: String {
        "matrixitem:chs.act.gov.au"
    }
    
    var avatarURL: String? {
        nil
    }
    
    var displayName: String {
        longName
    }
    
    init(name: String) {
        longName = name
    }
}
