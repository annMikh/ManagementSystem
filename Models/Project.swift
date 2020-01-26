//
//  Project.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 26.01.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation


class Project {
    
    init(name: String, description: String, accessType: AccessType = AccessType.open) {
        self.name = name
        self.description = description
        self.accessType = accessType
    }
    
    var name: String
    var description: String
    var accessType: AccessType
    
    
    var tags = Set<Tag>()
    var participants = Set<User>()
    
}
