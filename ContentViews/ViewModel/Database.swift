//
//  Database.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 23.03.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

class Database : ObservableObject {
    
    static let shared = Database()
    
    let db = Firestore.firestore()
    
    private init() { }
    
    func getProjects(me: FirebaseAuth.UserInfo?, com: @escaping FIRQuerySnapshotBlock) {
        db.collection("projects")
            .whereField("participants", arrayContains: me?.uid ?? "").getDocuments(completion: com)
    }

    
    func getTasks(project: Project, com: @escaping FIRQuerySnapshotBlock) {
        db.collection("tasks")
            .whereField("project", isEqualTo: project.id).getDocuments(completion: com)
    }
    
    func getComments(task: Task, com: @escaping FIRQuerySnapshotBlock) {
        db.collection("comments")
            .whereField("task", isEqualTo: task.id)
            .getDocuments(completion: com)
    }
    
    func getUser(userId: String, com: @escaping FIRDocumentSnapshotBlock) {
        db.collection("users").document(userId).getDocument(completion: com)
    }
    
    func getUsers(com: @escaping FIRQuerySnapshotBlock) {
        db.collection("users").getDocuments(completion: com)
    }
    
    func loadProjects(com: @escaping FIRQuerySnapshotBlock) {
        db.collection("projects").getDocuments(completion: com)
    }
}
