//
//  CustomTimelineElement.swift
//  Riot
//
//  Created by Joseph Fergusson on 13/7/21.
//  Copyright © 2021 matrix.org. All rights reserved.
//

import Foundation


@objcMembers class CustomTimelineElement: MXKRoomBubbleCellData {
    func ReuseIdentifier() -> String {
        "FakeCell"
    }
    var initialRender: Bool = true
    func getState(callback: @escaping () -> Void) {
        
    }
    func drawCell(cell: UITableViewCell, requestUpdate: @escaping () -> Void) {
        
    }
    var shouldRequestUpdate = true
    func render(cell: UITableViewCell, requestUpdate: @escaping () -> Void) {
        if initialRender {
            getState {
                self.initialRender = false
                self.shouldRequestUpdate = true
                self.render(cell: cell, requestUpdate: requestUpdate)
            }
        } else {
            drawCell(cell: cell, requestUpdate: requestUpdate)
            if shouldRequestUpdate {
                requestUpdate()
                shouldRequestUpdate = false
            }
        }
    }
    func height(withWidth: CGFloat) -> CGFloat {
        return 0
    }
    var containsLastMessage: Bool = false
    var componentIndexOfSentMessageTick: Int = 0
}
