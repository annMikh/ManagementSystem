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
    
    private let db = Firestore.firestore()
    
    private init() { }
    
    /// load project for participant of one
    func getProjects(me: FirebaseAuth.UserInfo?, com: @escaping FIRQuerySnapshotBlock) {
        db.projects
            .whereField("participants", arrayContains: me?.uid ?? "")
            .order(by: "date", descending: true)
            .limit(to: 100)
            .getDocuments(completion: com)
    }

    /// load tasks for project
    func getTasks(project: Project, com: @escaping FIRQuerySnapshotBlock) {
        db.tasks
            .whereField("project", isEqualTo: project.id)
            .order(by: "date", descending: true)
            .limit(to: 100)
            .getDocuments(completion: com)
    }
    
    /// load comments for task
    func getComments(task: Task, com: @escaping FIRQuerySnapshotBlock) {
        db.comments
            .whereField("task", isEqualTo: task.id)
            .order(by: "date", descending: true)
            .limit(to: 50)
            .getDocuments(completion: com)
    }
    
    /// load user info by id
    func getUser(userId: String, com: @escaping FIRDocumentSnapshotBlock) {
        db.users
            .document(userId)
            .getDocument(completion: com)
    }
    
    /// load users for search as participants or assigned user
    func getUsers(com: @escaping FIRQuerySnapshotBlock) {
        db.users
            .order(by: "email")
            .limit(to: 100)
            .getDocuments(completion: com)
    }
    
    /// load projects for search
    func loadProjects(com: @escaping FIRQuerySnapshotBlock) {
        db.projects
            .whereField("accessType", isEqualTo: "open")
            .order(by: "date", descending: true)
            .limit(to: 100)
            .getDocuments(completion: com)
    }
}
