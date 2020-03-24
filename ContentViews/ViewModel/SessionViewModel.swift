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
    }
    
    func createProject(project: Project) {
    }
    
    func createTask(task: Task) {
    }
    
}
