//
//  Practitioner.swift
//  Riot
//
//  Created by Joseph Fergusson on 10/7/21.
//  Copyright © 2021 matrix.org. All rights reserved.
//

import Foundation

protocol Practitioner: MatrixItem, UnassociatedEquatable {
    var name: String { get }
    func GetRoles(callback: ([PractitionerRole]) -> Void)
    var jobTitle: String { get }
    var businessUnit: String { get }
    var organisation: String { get }
    var ID: String { get }
    var phoneNumber: String? { get }
    var emailAddress: String? { get }
    var onlineStatus: Bool { get }
    var activeStatus: Bool { get }
}

extension Practitioner {
    func same(rhs: Any) -> Bool {
        let left = self as Practitioner
        if let right = rhs as? Practitioner {
            return left.matrixID == right.matrixID && left.ID == right.ID && left.name == right.name
        }
        return false
    }
}
