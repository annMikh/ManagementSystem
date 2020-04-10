//
//  Participants.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 08.04.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation

class Participants : ObservableObject {
    
    @Published var users = [User]()
    
    func fillParticipants(_ project: Project) {
        project.participants.forEach {
            Database.shared.getUser(userId: $0) { (doc, err) in
                if err == nil {
                    self.users.append(User(dictionary: doc?.data() ?? [String : Any]())!)
                }
            }
        }
    }

}
