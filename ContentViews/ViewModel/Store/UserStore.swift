//
//  UserStore.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 11.04.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import Combine

final class UserStore : ObservableObject {
    
    let objectWillChange = PassthroughSubject<User, Never>()
    @Published var users = [User]()
    
    private let db = Database.shared
    
    func loadUsers(ids: Set<String>) {
        self.db.getParticipants(ids: ids, com: self.handleUsers)
    }
    
    func loadUsers() {
        self.db.getUsers(com: self.handleUsers)
    }
    
    func loadUser(uid: String, handler: @escaping FIRDocumentSnapshotBlock) {
        self.db.getUser(userId: uid, com: handler)
    }
    
    private func handleUsers(snap: QuerySnapshot?, err: Error?) {
        if err != nil {
            print((err?.localizedDescription)!)
            return
        }
        users.removeAll()
        snap?.documents.forEach{
            let u = User(document: $0)!
            users.append(u)
            self.update(item: u)
        }
    }
    
    private func update(item: User) {
        objectWillChange.send(item)
    }
    
    func clear() {
        users = [User]()
    }
    
}
