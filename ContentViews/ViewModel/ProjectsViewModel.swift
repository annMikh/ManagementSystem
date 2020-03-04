//
//  ProjectsState.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 03.03.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation
import Firebase

class ProjectsViewModel: ObservableObject  {
    
    @Published var session:Set<Project>?
    private let ref = Database.database().reference()
    
//    func getAllProjectsForUser(userId: Int) -> Set<Int> {
////        ref.child("projects").child(userId)
////            .observeSingleEvent(of: .value, with: { (snapshot) in
////
////          let value = snapshot.value as? NSDictionary
////          let user = User(username: username)
////
////          }) { (error) in
////            print(error.localizedDescription)
////        }
//    }
    
}
