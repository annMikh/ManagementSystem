//
//  Project.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 26.01.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation


class Project : Hashable, Codable, ObservableObject  {
    
    init(name: String, description: String, accessType: AccessType = AccessType.open) {
        self.name = name
        self.description = description
        self.accessType = accessType
        self.date = Date()
        self.tasks = [User : [Task]]()
        self.participants = []
        self.tags = Set<Tag>()
    }
    
    static func == (lhs: Project, rhs: Project) -> Bool {
        return lhs.name == rhs.name && lhs.description == rhs.description && lhs.accessType == rhs.accessType
            && lhs.participants == rhs.participants && lhs.tags == rhs.tags
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(description)
    }
    
    var name: String
    var description: String
    var accessType: AccessType
    var date: Date
    
    var tags : Set<Tag>
    var participants : [User]
    
    var tasks : [User : [Task]]
    
}
