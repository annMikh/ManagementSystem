//
//  AthorizedUser.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 26.02.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift


class SessionViewModel : ObservableObject {
    
    @Published var session: User?
    @Published var isLogIn: Bool?
    static var me : User?
    
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
        do {
            try db.collection("users").document().setData(from: user) { err in
                print(err == nil ? "no error" : err!)
            }
        } catch let err {
            print(err)
        }
    }
    
    func createProject(project: Project) {
        do {
            try db.collection("projects").document().setData(from: project) { err in
                print(err == nil ? "no error" : err!)
            }
        } catch let err {
            print(err)
        }
    }
    
    func createTask(task: Task) {
        do {
            try db.collection("tasks").document().setData(from: task) { err in
                print(err == nil ? "no error" : err!)
            }
        } catch let err {
            print(err)
        }
    }
    
}
