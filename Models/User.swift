//
//  User.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 26.01.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation


class User : Codable, Hashable, ObservableObject {
    
    init(name: String, lastName: String, position: Position, email: String) {
        self.name = name
        self.lastName = lastName
        self.position = position
        self.email = email
        self.id = nil
        self.projects = Set<Project>()
        self.tasks = Set<Task>()
    }
    
    init(user: User?) {
        self.name = user?.name ?? ""
        self.lastName = user?.lastName ?? ""
        self.position = user?.position ?? Position.None
        self.email = user?.email ?? ""
        self.projects = Set<Project>()
        self.tasks = Set<Task>()
    }
    
    var name: String
    var lastName: String
    var email: String
    var position: Position
    var id: Int?
    
    var projects: Set<Project>
    var tasks: Set<Task>
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name //todo delete name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(lastName)
        hasher.combine(position)
        hasher.combine(id)
    }
    
    func getFullName() -> String {
        return "\(name) \(lastName)"
    }

}
