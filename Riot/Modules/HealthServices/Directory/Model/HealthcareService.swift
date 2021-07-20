//
//  HealthcareService.swift
//  Riot
//
//  Created by Joseph Fergusson on 19/7/21.
//  Copyright © 2021 matrix.org. All rights reserved.
//

import Foundation
protocol HealthcareService {
    var Name: String { get }
    var Phone: String { get }
    var LocationFirstLine: String { get }
    var LocationSecondLine: String { get }
}
