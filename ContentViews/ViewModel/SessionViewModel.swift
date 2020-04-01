//
//  AthorizedUser.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 26.02.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation
import Firebase

class SessionViewModel : ObservableObject {
    
    static let shared = SessionViewModel()
    
    private init() {
        currentSession()
    }
    
    var session: Firebase.User?
    var currentUser : User?
    
    // MARK: for main and login  flow
    func currentSession() {
        self.session = Auth.auth().currentUser
        self.getUserInfo(user: self.session) { (doc, err) in
            if err == nil {
                let result = Result {
                    try doc.map {
                        try $0.data(as: User.self)
                    }
                }
                switch result {
                    case .success(let u):
                        self.currentUser = u!
                    case .failure(let error):
                        print("Error decoding user: \(error)")
                }
                
            }
        }
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            // TODO
            //self.session = auth.currentUser
        }
    }
    
    func logIn(email: String, password: String, handler: @escaping AuthDataResultCallback) {
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
    }
    
    func logOut() throws {
        try Auth.auth().signOut()
        self.session = Auth.auth().currentUser
    }
    
    func signUp(email: String, password: String, handler: @escaping AuthDataResultCallback) {
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
    }
    
    func resetPassword(email: String, handler: @escaping SendPasswordResetCallback) {
        Auth.auth().sendPasswordReset(withEmail: email, completion: handler)
    }
    
    // MARK: register flow
    func createUser(_ user: User) {
        self.session = Auth.auth().currentUser
        db.collection(SessionViewModel.USERS).document(user.uid).setData([
            "name": user.name,
            "lastName": user.lastName,
            "email": user.email,
            "position": user.position.rawValue,
            "uid": user.uid
        ]) { err in
            if let err = err {
                self.currentSession()
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func getUserInfo(user: Firebase.User?, handler: @escaping FIRDocumentSnapshotBlock) {
        db.collection(SessionViewModel.USERS).document(user?.uid ?? "").getDocument(completion: handler)
    }
    
    func createProject(_ project: Project) {
        let id = project.hashValue
        project.id = id
        self.refProjects.document(String(id)).setData([
            "name": project.name,
            "description": project.description,
            "date": project.date,
            "accessType":  project.accessType.rawValue,
            "creator": project.creator,
            "participants": project.participants,
            "tasks": project.tasks,
            "tag": project.tag,
            "id": id
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func createTask(task: Task, project: Project) {
        self.refTasks.document(String(task.hashValue)).setData([
            "author": task.author.bound,
            "name": task.name.bound,
            "date": task.date,
            "description": task.description.bound,
            "assignedUser": task.assignedUser.bound,
            "priority": task.priority.rawValue,
            "status": task.status.rawValue,
            "deadline": task.deadline ?? Deadline.NoDeadline.rawValue,
            "project_id": project.id
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                self.updateProject(project, task)
                print("Document successfully written!")
            }
        }
    }
    
    private func updateProject(_ project: Project, _ task: Task) {
        project.tasks.append(task.hashValue)
        self.refProjects.document(String(project.id)).updateData([
            "tasks": project.tasks
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func deleteProject(_ project: Project, com: @escaping (Error?) -> Void) {
        self.refProjects.document(String(project.id)).delete(completion: com)
    }
    
    private static let PROJECTS = "projects"
    private static let TASKS = "tasks"
    private static let USERS = "users"
    
    private let db = Firestore.firestore()
    private lazy var refProjects = db.collection(SessionViewModel.PROJECTS)
    private lazy var refTasks = db.collection(SessionViewModel.TASKS)
    private lazy var refUsers = db.collection(SessionViewModel.USERS)
}
