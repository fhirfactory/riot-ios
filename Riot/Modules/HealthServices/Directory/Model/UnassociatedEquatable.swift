//
//  UnassociatedEquatable.swift
//  Riot
//
//  Created by Joseph Fergusson on 12/7/21.
//  Copyright © 2021 matrix.org. All rights reserved.
//

import Foundation

protocol UnassociatedEquatable {
    func same(rhs: Any) -> Bool
}
