//
//  BaseGenericDirectoryCell.swift
//  Riot
//
//  Created by Joseph Fergusson on 8/7/21.
//  Copyright © 2021 matrix.org. All rights reserved.
//

import Foundation
import UIKit

class BaseGenericDirectoryCell<T>: UITableViewCell {
    func bind(data: T, index: Int) {
        preconditionFailure("Override")
    }
}

protocol ProvidesReuseIdentifierAndNib {
    static func getReuseIdentifier() -> String
    static func getNib() -> UINib
}
