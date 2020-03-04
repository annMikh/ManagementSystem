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


class SessionViewModel : ObservableObject {
    
    @Published var session: User?
    @Published var isLogIn: Bool?
    
    let db = Firestore.firestore()
    
    func listen() {
        _ = Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
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
    
    func createUser() {
        var ref: DocumentReference? = nil
        ref = db.collection("users").addDocument(data: [
            "name": "anya",
            "lastName": "mikhaleva",
            "position": "$\(Position.Designer)",
            "projects": "[1, 2, 3]",
            "tasks": "[3, 4, 5, 6]"
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
}
