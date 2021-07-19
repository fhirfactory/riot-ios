//
//  PatientTagPlaceholder.swift
//  Riot
//
//  Created by Joseph Fergusson on 13/7/21.
//  Copyright © 2021 matrix.org. All rights reserved.
//

import Foundation

@objc class PatientTagPlaceholder: CustomTimelineElement {
    override func ReuseIdentifier() -> String {
        "LegacyTagViewContainer"
    }
    var tagData: [TagData] = []
    
    override func getState(callback: @escaping () -> Void) {
        Services.ImageTagDataService().LookupTagInfoForObjc(URL: URL) { arr in
            if let tags = arr as? [TagData] {
                self.tagData = tags
                callback()
            }
        }
    }
    override func drawCell(cell: UITableViewCell, requestUpdate: @escaping () -> Void) {
        if let typedCell = cell as? LegacyTagViewContainer {
            typedCell.render(with: tagData)
        }
    }
    override func height(withWidth: CGFloat) -> CGFloat {
        return LegacyTagViewContainer.calculateHeight(tags: tagData, withWidth: withWidth)
    }
    var URL: String!
}
