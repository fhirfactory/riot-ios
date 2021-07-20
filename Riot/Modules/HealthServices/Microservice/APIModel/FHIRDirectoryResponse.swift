//
//  FHIRDirectoryResponse.swift
//  Riot
//
//  Created by Joseph Fergusson on 19/7/21.
//  Copyright © 2021 matrix.org. All rights reserved.
//

import Foundation
class FHIRDirectoryResponse<T: Codable>: Codable {
    var id: String!
    var created: Bool!
    var entry: T!
}
