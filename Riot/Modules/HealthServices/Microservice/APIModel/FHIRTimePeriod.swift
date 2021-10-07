//
//  FHIRTimePeriod.swift
//  Riot
//
//  Created by Joseph Fergusson on 19/7/21.
//  Copyright © 2021 matrix.org. All rights reserved.
//

import Foundation

class FHIRTimePeriod: Codable {
    var startDate: Int64!
    var endDate: Int64?
}
