//
//  Project.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 26.01.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation
import Firebase

class Project : Hashable, Codable, ObservableObject  {
    
    init(name: String = "", description: String = "", accessType: AccessType = AccessType.open, creator: String = "", tag: String = "", id: Int = 0) {
        self.name = name
        self.description = description
        self.accessType = accessType
        self.date = Date()
        self.creator = creator
        self.id = id
        self.tag = tag
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
    var creator: String
    var date: Date
    var id: Int
    
    var participants = [String]()
    var tasks = [Int]()
    var tag : String
    
}
