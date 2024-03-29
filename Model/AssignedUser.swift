//
//  AssignedUser.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 08.04.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation


class AssignedUser : ObservableObject {
    
    @Published var user : User
    
    init(user: User = User(name: "",
                            lastName: "",
                            email: "",
                            position: Position.None,
                            uid: "")) {
        self.user = user
    }
    
    func isNotEmpty() -> Bool {
        return !self.user.email.isEmpty
    }
}
