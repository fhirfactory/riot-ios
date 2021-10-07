//
//  FHIRName.swift
//  Riot
//
//  Created by Joseph Fergusson on 19/7/21.
//  Copyright © 2021 matrix.org. All rights reserved.
//

import Foundation
class FHIRName: Codable {
    var nameUse: String!
    var displayName: String!
    var familyName: String!
    var givenNames: [String] = []
    var preferredGivenName: String!
    var prefixes: [String] = []
    var suffixes: [String] = []
    var period: FHIRTimePeriod!
}
