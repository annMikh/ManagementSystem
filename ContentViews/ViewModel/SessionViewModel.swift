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
    
    @Published var session: User?
    @Published var isLogIn: Bool?
    static var me : User? = User(name: "anna", lastName: "mikhaleva", position: Position.Manager, email: "dfdv")
    
    let db = Firestore.firestore()
    
    func listen() {
        _ = Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                self.session = nil
                self.isLogIn = true
                SessionViewModel.me = nil
            } else {
                self.isLogIn = false
                self.session = nil
                SessionViewModel.me = nil
            }
        }
    }
    
    func logIn(email: String, password: String, handler: @escaping AuthDataResultCallback) {
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
    }
    
    func signUp(email: String, password: String, handler: @escaping AuthDataResultCallback) {
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
    }
    
    func createUser(user: User) {
        db.collection("users").document(String(user.hashValue)).setData([
            "name": user.name,
            "lastName": user.lastName,
            "email": user.email,
            "position": user.position,
            "projects": user.projects
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func createProject(project: Project) {
        db.collection("projects").document(String(project.hashValue)).setData([
            "name": project.name,
            "description": project.description,
            "date": project.date,
            "accessType":  project.accessType,
            "creator": project.creator,
            "participants": project.participants,
            "tags": project.tags,
            "tasks": project.tasks
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func createTask(task: Task, project: Project) {
        var tasks = project.tasks
        tasks.append(task)
        db.collection("projects").document(String(project.hashValue)).updateData([
            "tasks": tasks
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
}
