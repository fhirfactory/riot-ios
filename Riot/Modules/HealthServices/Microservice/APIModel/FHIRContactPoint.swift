//
//  FHIRContactPoint.swift
//  Riot
//
//  Created by Joseph Fergusson on 19/7/21.
//  Copyright © 2021 matrix.org. All rights reserved.
//

import Foundation
class FHIRContactPoint: Codable {
    var name: String!
    var value: String!
    var rank: Int!
    var type: String!
    var use: String!
}
