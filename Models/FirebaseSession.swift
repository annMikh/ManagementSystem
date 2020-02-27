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


class FirebaseSession : ObservableObject {
    
    @Published var session: User?
    @Published var isLogIn: Bool?
    
    func listen() {
        _ = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                self.session = User()
                self.isLogIn = true
            } else {
                self.isLogIn = false
                self.session = nil
            }
        }
    }
    
    func logIn(email: String, password: String, handler: @escaping AuthDataResultCallback) {
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
    }
    
    func signUp(email: String, password: String, handler: @escaping AuthDataResultCallback) {
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
    }
    
}
