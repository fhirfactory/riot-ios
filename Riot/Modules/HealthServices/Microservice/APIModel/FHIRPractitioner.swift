//
//  FHIRPractitioner.swift
//  Riot
//
//  Created by Joseph Fergusson on 19/7/21.
//  Copyright © 2021 matrix.org. All rights reserved.
//

import Foundation
class FHIRPractitioner: Codable {
    var simplifiedID: String!
    var identifiers: [FHIRIdentifier] = []
    var displayName: String!
    var systemManaged: Bool!
    var officialName: FHIRName!
    var otherNames: [FHIRName] = []
    var contactPoints: [FHIRContactPoint] = []
    var currentPractitionerRoles: [FHIRPractitionerRole] = []
    var matrixId: String!
    var organisationStructure: [FHIROrganizationItem]
    var mainJobTitle: String?
    var practitionerStatus: FHIRStatus
}
