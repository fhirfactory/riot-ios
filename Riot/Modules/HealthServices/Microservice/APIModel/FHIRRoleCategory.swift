//
//  FHIRRoleCategory.swift
//  Riot
//
//  Created by Joseph Fergusson on 19/7/21.
//  Copyright © 2021 matrix.org. All rights reserved.
//

import Foundation
class FHIRRoleCategory: Codable {
    var simplifiedID: String!
    var identifiers: [FHIRIdentifier] = []
    var description: String?
    var displayName: String!
    var roles: [String] = []
}
