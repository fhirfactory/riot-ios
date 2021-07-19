//
//  TimelineCell.swift
//  Riot
//
//  Created by Joseph Fergusson on 19/7/21.
//  Copyright © 2021 matrix.org. All rights reserved.
//

import Foundation

@objcMembers class TimelineCell<T>: UITableViewCell {
    func render(with data: T) {
        preconditionFailure("Override in deriving class")
    }
    func getHeight(from data: T, withWidth width: CGFloat) -> CGFloat {
        preconditionFailure("Override in deriving class")
    }
}
