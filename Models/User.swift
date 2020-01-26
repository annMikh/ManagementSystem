//
//  User.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 26.01.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation


class User : Hashable {
    
    var name: String = ""
    var lastName: String = ""
    var position = Position.Other
    
    var projects = Set<Project>()
    var tasks = Set<Task>()
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.name == rhs.name && lhs.lastName == rhs.lastName && lhs.position == rhs.position
            && lhs.projects == rhs.projects && lhs.tasks == lhs.tasks
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(lastName)
    }

}
