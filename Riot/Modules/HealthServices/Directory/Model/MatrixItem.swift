//
//  MatrixItem.swift
//  Riot
//
//  Created by Joseph Fergusson on 10/7/21.
//  Copyright © 2021 matrix.org. All rights reserved.
//

import Foundation

protocol MatrixItem {
    var matrixID: String { get }
    var displayName: String { get }
    var avatarURL: String? { get }
}

extension MatrixItem {
    var displayName: String {
        return matrixID
    }
}
