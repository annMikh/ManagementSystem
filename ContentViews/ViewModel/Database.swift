//
//  Database.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 23.03.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class Database : ObservableObject {
    
    let db = Firestore.firestore()
    
    func getProjects(me: User, com: @escaping FIRQuerySnapshotBlock) {
        db.collection("projects")
            .whereField("participants", arrayContains: me.uid).getDocuments(completion: com)
    }

    
    func getTasks(project: Project, com: @escaping FIRQuerySnapshotBlock) {
        db.collection("tasks")
            .whereField("project_id", isEqualTo: project.id).getDocuments(completion: com)
    }
    
    func getUser(userId: String, com: @escaping FIRDocumentSnapshotBlock) {
        db.collection("user").document(userId).getDocument(completion: com)
    }
    
    func loadProjectsByName(input: String, com: @escaping FIRQuerySnapshotBlock) {
        db.collection("projects").whereField("name", isEqualTo: input).getDocuments(completion: com)
    }
}
