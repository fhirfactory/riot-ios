//
//  PractitionerRole.swift
//  Riot
//
//  Created by Joseph Fergusson on 10/7/21.
//  Copyright © 2021 matrix.org. All rights reserved.
//

import Foundation

protocol PractitionerRole: MatrixItem {
    var longName: String { get }
    var shortName: String { get }
    var orgName: String { get }
    var roleName: String { get }
    var roleCategory: String { get }
    var location: String { get }
    func GetPractitioners(callback: ([Practitioner]) -> Void)
    var ID: String { get }
    var active: Bool { get }
}
