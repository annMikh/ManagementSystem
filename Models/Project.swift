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
        self.creator = User(name: "fsdfds", lastName: "fghjkfd", position: Position.Manager, email: "dfdfd")
        
        let u = self.creator
        let a = User(name: "anya", lastName: "mikhaleva", position: Position.Designer, email: "adsds")
        let b = Task.builder(author: u, assignee: a)
        b.setDescription(description: "fdshfhdsjfs")
        b.setDeadline(deadline: Date())
        b.setName(name: "fdhsfjhd")
        
        self.tasks = [b.build()]
        self.participants = []
        self.tags = Set<Tag>()
    }
    
    static func == (lhs: Project, rhs: Project) -> Bool {
        return lhs.creator == rhs.creator && lhs.date == rhs.date
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(creator)
        hasher.combine(date)
    }
    
    var name: String
    var description: String
    var accessType: AccessType
    var creator: User
    var date: Date
    
    var tags : Set<Tag>
    var participants : [User]
    var tasks : [Task]
    
}
