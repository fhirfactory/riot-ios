//
//  RoleModel.swift
//  Riot
//
//  Created by Naurin Afrin on 31/7/20.
//  Copyright © 2020 matrix.org. All rights reserved.
//

import Foundation

class RoleModel: PractitionerRole, Equatable {
    var longName: String {
        innerRole.longName
    }
    
    var shortName: String {
        innerRole.shortName
    }
    
    var orgName: String {
        innerRole.orgName
    }
    
    var roleName: String {
        innerRole.roleName
    }
    
    var roleCategory: String {
        innerRole.roleCategory
    }
    
    var location: String {
        innerRole.location
    }
    
    func GetPractitioners(callback: ([Practitioner]) -> Void) {
        
    }
    
    var ID: String {
        innerRole.ID
    }
    
    var active: Bool {
        innerRole.active
    }
    
    var matrixID: String {
        innerRole.matrixID
    }
    
    var avatarURL: String? {
        innerRole.avatarURL
    }
    
    var displayName: String {
        innerRole.displayName
    }
    
    static func == (lhs: RoleModel, rhs: RoleModel) -> Bool {
        lhs.ID == rhs.ID && lhs.matrixID == rhs.matrixID && lhs.displayName == rhs.displayName
    }
    
    var innerRole: PractitionerRole
    var isExpanded: Bool
    var isFilled: Bool = false
    //as with the others, this should be changed to be stored
    var Favourite: Bool = false
    init(innerRole: PractitionerRole, isExpanded: Bool = false) {
        self.innerRole = innerRole
        self.isExpanded = isExpanded
    }
}
