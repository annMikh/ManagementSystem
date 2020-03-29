//
//  User.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 26.01.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation


class User : Codable, Hashable, ObservableObject {
    
    init(name: String, lastName: String, position: Position, email: String, uid: String) {
        self.name = name
        self.lastName = lastName
        self.position = position
        self.email = email
        self.uid = uid
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
        self.uid = ""
    }
    
    var name: String
    var lastName: String
    var email: String
    var position: Position
    var uid: String
    
    var projects: Set<Project>
    var tasks: Set<Task>
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.email == rhs.email
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(email)
    }
    
    func getFullName() -> String {
        return "\(name) \(lastName)"
    }

}
