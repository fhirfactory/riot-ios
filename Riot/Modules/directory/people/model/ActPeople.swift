//
//  ActPeople.swift
//  Riot
//
//  Created by Naurin Afrin on 3/8/20.
//  Copyright © 2020 matrix.org. All rights reserved.
//

import Foundation

struct ActPeople {
    var baseUser: MXUser
    var officialName: String
    var jobTitle: String
    var organisation: String
    var businessUnit: String
    var isExpanded: Bool
    var emailAddress: String?
    var phoneNumber: String?
    init(withBaseUser baseUser: MXUser, officialName name: String, jobTitle: String, org: String, businessUnit: String) {
        self.baseUser = baseUser
        self.officialName = name
        self.jobTitle = jobTitle
        self.organisation = org
        self.businessUnit = businessUnit
        self.isExpanded = false
    }
}
