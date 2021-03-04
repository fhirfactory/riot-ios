//
//  ActPeople.swift
//  Riot
//
//  Created by Naurin Afrin on 3/8/20.
//  Copyright © 2020 matrix.org. All rights reserved.
//

import Foundation

@objcMembers class ActPeople: NSObject {
    var baseUser: MXUser!
    var officialName: String!
    var jobTitle: String!
    var organisation: String!
    var businessUnit: String!
    
    var emailAddress: String?
    var phoneNumber: String?
    override init() {
        
    }
    
    init(withBaseUser baseUser: MXUser, officialName name: String, jobTitle: String, org: String, businessUnit: String) {
        self.baseUser = baseUser
        self.officialName = name
        self.jobTitle = jobTitle
        self.organisation = org
        self.businessUnit = businessUnit
    }
    static func == (lhs: ActPeople, rhs: ActPeople) -> Bool {
        lhs.baseUser.userId == rhs.baseUser.userId
    }
}


class ActPeopleModel: ActPeople {
    private var _favourite = false
    var isExpanded: Bool = false
    //Update some database or something when this changes
    var Favourite: Bool {
        get {
            return _favourite
        }
        set(value) {
            _favourite = value
        }
    }
    
    //this is kind of sketchy and might have unforeseen consequences for memory management
    init(fromActPerson: ActPeople) {
        super.init()
        let children = Mirror(reflecting: fromActPerson).children
        for child in children {
            guard let label = child.label else { continue }
            self.setValue(child.value, forKey: label)
        }
    }
    override init(withBaseUser baseUser: MXUser, officialName name: String, jobTitle: String, org: String, businessUnit: String) {
        super.init(withBaseUser: baseUser, officialName: name, jobTitle: jobTitle, org: org, businessUnit: businessUnit)
    }
}
