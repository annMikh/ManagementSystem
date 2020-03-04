//
//  User.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 26.01.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation


class User : NSObject, ObservableObject {
    
    init(name: String, lastName: String, position: Position) {
        self.name = name
        self.lastName = lastName
        self.position = position
    }
    
    convenience override init() {
        self.init(name: "anna", lastName: "mikhaleva", position: Position.Developer)
    }
    
    var name: String = ""
    var lastName: String = ""
    var position = Position.Other
    
    var projects = Set<Project>()
    var tasks = Set<Task>()
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.name == rhs.name && lhs.lastName == rhs.lastName && lhs.position == rhs.position
            && lhs.projects == rhs.projects && lhs.tasks == lhs.tasks
    }

}
