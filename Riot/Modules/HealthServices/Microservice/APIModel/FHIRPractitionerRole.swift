//
//  FHIRPractitionerRole.swift
//  Riot
//
//  Created by Joseph Fergusson on 19/7/21.
//  Copyright © 2021 matrix.org. All rights reserved.
//

import Foundation

class FHIRPractitionerRole: Codable {
    var simplifiedID: String!
    var identifiers: [FHIRIdentifier] = []
    var displayName: String!
    var description: String!
    var systemManaged: Bool!
    var primaryOrganizationID: String!
    var primaryLocationID: String!
    var primaryRoleID: String!
    var contactPoints: [FHIRContactPoint] = []
    var primaryRoleCategoryID: String!
    var roleHistory: FHIRRoleHistory?
    var activePractitionerSet: [FHIRPractitioner]
}
