//
//  FHIRHealthcareService.swift
//  Riot
//
//  Created by Joseph Fergusson on 19/7/21.
//  Copyright © 2021 matrix.org. All rights reserved.
//

import Foundation
class FHIRHealthcareService: Codable {
    var displayName: String!
    var systemManaged: Bool!
    var identifiers: [FHIRIdentifier] = []
    var simplifiedID: String!
    var organisationalUnit: String!
}
