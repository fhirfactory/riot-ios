//
//  RoleModel.swift
//  Riot
//
//  Created by Naurin Afrin on 31/7/20.
//  Copyright © 2020 matrix.org. All rights reserved.
//

import Foundation

class RoleModel: Equatable {
    static func == (lhs: RoleModel, rhs: RoleModel) -> Bool {
        lhs.innerRole == rhs.innerRole
    }
    
    var innerRole: Role
    var isExpanded: Bool
    var isFilled: Bool = false
    //as with the others, this should be changed to be stored
    var Favourite: Bool = false
    init(innerRole: Role, isExpanded: Bool) {
        self.innerRole = innerRole
        self.isExpanded = isExpanded
    }
}

class RoleSelectable: Equatable {
    static func == (lhs: RoleSelectable, rhs: RoleSelectable) -> Bool {
        lhs.innerRole == rhs.innerRole
    }
    
    var innerRole: Role
    var isExpanded: Bool
    var isOnDuty: Bool
    var isSelected: Bool
    init(innerRole: Role, isExpanded: Bool) {
        self.innerRole = innerRole
        self.isExpanded = isExpanded
        isOnDuty = false
        isSelected = false
    }
}
