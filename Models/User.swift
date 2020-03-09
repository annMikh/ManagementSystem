//
//  User.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 26.01.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation


class User : NSObject, ObservableObject {
    
    init(name: String, lastName: String, position: Position, id: Int) {
        self.name = name
        self.lastName = lastName
        self.position = position
        self.id = id
    }
    
    convenience override init() {
        self.init(name: "anna", lastName: "mikhaleva", position: Position.Developer, id: 0)
    }
    
    var name: String = ""
    var lastName: String = ""
    var position = Position.Other
    var id: Int
    
    var projects = Set<Project>()
    var tasks = Set<Task>()
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
    
    func getFullName() -> String {
        return "\(name) \(lastName)"
    }

}
