//
//  FHIRIdentifier.swift
//  Riot
//
//  Created by Joseph Fergusson on 19/7/21.
//  Copyright © 2021 matrix.org. All rights reserved.
//

import Foundation
class FHIRIdentifier: Codable {
    var type: String!
    var use: String!
    var value: String!
    var leafValue: String?
}
