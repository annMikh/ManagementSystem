//
//  Database.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 23.03.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation
import Firebase

class Database : ObservableObject {
    
    let db = Firestore.firestore()
    
    func getProjects(me: User) { //-> [Project] {
        db.collection("projects")
            .whereField("projects", arrayContains: me.projects.map { $0.hashValue} )
            .addSnapshotListener { querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print("Error retreiving snapshots \(error!)")
                    return
                }
                print("Current projects: \(snapshot.documents.map { $0.data() })")
            }
    }
}
