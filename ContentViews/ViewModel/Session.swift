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
import SwiftUI

class Session {
    
    static let shared = Session()
    
    var image = UIImage(systemName: "person")
    
    private init() {
        Auth.auth().addStateDidChangeListener { (auth, newUser) in
          self.setUser(firebaseUser: newUser)
        }
    }
    
    var session: FirebaseAuth.UserInfo?
    var currentUser : User?
    let db = Firestore.firestore()
    
    // MARK: for main and login flow
    
    func currentSession() {
        self.session = Auth.auth().currentUser
        self.setUser(firebaseUser: Auth.auth().currentUser)
    }
    
    func setUser(firebaseUser: FirebaseAuth.UserInfo?) {
        if let firebaseUser = firebaseUser {
            self.getProfile(user: firebaseUser.uid) { (doc, err) in
                if err == nil && doc != nil {
                    self.currentUser = User(dictionary: doc?.data() ?? [String : Any]())!
                    StorageManager().downloadImage(uid: self.currentUser.bound.uid) { data, err in
                        if err == nil && data != nil {
                            self.image = UIImage(data: data!)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: login/auth user
    
    func logIn(email: String, password: String, handler: @escaping AuthDataResultCallback) {
        DispatchQueue.main.async {
            Auth.auth().signIn(withEmail: email, password: password, completion: handler)
        }
    }
    
    func logOut() throws {
        try Auth.auth().signOut()
    }
    
    func signUp(email: String, password: String, handler: @escaping AuthDataResultCallback) {
        DispatchQueue.global(qos: .utility).async {
            Auth.auth().createUser(withEmail: email, password: password, completion: handler)
        }
    }
    
    func resetPassword(email: String, handler: @escaping SendPasswordResetCallback) {
        DispatchQueue.global(qos: .utility).async {
            Auth.auth().sendPasswordReset(withEmail: email, completion: handler)
        }
    }
    
    // MARK: register flow
    
    func createUser(_ user: User) {
        self.currentUser = user
        DispatchQueue.global(qos: .utility).async {
           self.db.users.document(user.uid).setData(user.documentData)
        }
    }
    
    // MARK: profile
    
    func getProfile(user: String, handler: @escaping FIRDocumentSnapshotBlock) {
        DispatchQueue.global(qos: .utility).async {
           self.db.users.document(user).getDocument(completion: handler)
        }
    }
    
    func updateProfile(user: User?) {
        DispatchQueue.global(qos: .utility).async {
           self.db.users.document(user.bound.uid).updateData(user.bound.documentData)
        }
    }
    
    // MARK: project
    
    func createProject(_ project: Project) {
        DispatchQueue.global(qos: .utility).async {
            self.db.projects.document(project.id).setData(project.documentData)
        }
    }
    
    func updateProject(_ project: Project) {
        DispatchQueue.global(qos: .utility).async {
            self.db.projects.document(project.id).updateData(project.documentData)
        }
    }
    
    func deleteProject(_ project: Project, com: @escaping (Error?) -> Void) {
        DispatchQueue.global(qos: .utility).async {
           self.db.projects.document(project.id).delete(completion: com)
        }
    }
    
    // MARK: task
    
    func createTask(task: Task) {
        DispatchQueue.global(qos: .utility).async {
            self.db.tasks.document(task.id).setData(task.documentData)
        }
    }
    
    func updateTask(_ task: Task) {
        DispatchQueue.global(qos: .utility).async {
            self.db.tasks.document(task.id).updateData(task.documentData)
        }
    }
    
    func deleteTask(_ task: Task, com: @escaping (Error?) -> Void) {
        DispatchQueue.global(qos: .utility).async {
           self.db.tasks.document(task.id).delete(completion: com)
        }
    }
    
    // MARK: comment
    
    func createComment(_ comment: Comment) {
        DispatchQueue.global(qos: .utility).async {
            self.db.comments.document(comment.id).setData(comment.documentData)
        }
    }
    
    func deleteComment(_ comment: Comment, com: @escaping (Error?) -> Void) {
        DispatchQueue.global(qos: .utility).async {
            self.db.comments.document(comment.id).delete(completion: com)
        }
    }
    
    func clearSession() {
        self.currentUser = nil
        self.session = nil
        self.image = UIImage(systemName: "person")
        CommentStore.shared.clear()
    }
}

extension Firestore {

  /// Returns a reference to the top-level users collection.
  var users: CollectionReference {
    return self.collection("users")
  }

  /// Returns a reference to the top-level projects collection.
  var projects: CollectionReference {
    return self.collection("projects")
  }

  /// Returns a reference to the top-level tasks collection.
  var tasks: CollectionReference {
    return self.collection("tasks")
  }
    
  /// Returns a reference to the top-level comments collection.
  var comments: CollectionReference {
    return self.collection("comments")
  }

}
