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
    
    @Published var session: Firebase.User?
    @Published var isLogIn: Bool?
    static var me : User?
    
    let db = Firestore.firestore()
    
    func currentSession() {
        self.session = Auth.auth().currentUser
        self.saveUserData(response: session)
        
//        var handle = Auth.auth().addStateDidChangeListener { (auth, user) in
//            print(user?.email)
//        }
    }
    
    func saveUserData(response: Firebase.User?) {
        self.session = response
        SessionViewModel.me = User(name: "",
                       lastName: "",
                       position: Position.None,
                       email: self.session?.email ?? "",
                       uid: self.session?.uid ?? "")
    }
    
    func logIn(email: String, password: String, handler: @escaping AuthDataResultCallback) {
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
    }
    
    func signUp(email: String, password: String, handler: @escaping AuthDataResultCallback) {
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
    }
    
    func createUser(user: User) {
        db.collection("users").document(user.uid).setData([
            "name": user.name,
            "lastName": user.lastName,
            "email": user.email,
            "position": user.position.rawValue,
            "uid": user.uid
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
            "accessType":  project.accessType.rawValue,
            "creator": project.creator
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
        db.collection("tasks").document(String(task.hashValue)).updateData([
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
