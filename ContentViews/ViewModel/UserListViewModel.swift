//
//  UserListViewModel.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 02.04.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation

final class UserListViewModel : ObservableObject {
    
    @Published var data = Set<User>()
    private var db = Database.shared
    
    init() {
        getUsers()
    }
    
    private func getUsers() {
        self.db.getUsers() { (snap, err) in
            if err != nil{
                print((err?.localizedDescription)!)
                return
            }
            snap?.documents.forEach{
                let u = User(document: $0)
                self.data.insert(u!)
            }
        }
    }
}
