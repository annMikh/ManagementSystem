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

class SessionViewModel {
    
    static let shared = SessionViewModel()
    
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
        setUser(firebaseUser: Auth.auth().currentUser)
    }
    
    func setUser(firebaseUser: FirebaseAuth.UserInfo?) {
        if let firebaseUser = firebaseUser {
            getProfile(user: firebaseUser.uid) { (doc, err) in
                if err == nil {
                    self.currentUser = User(dictionary: doc?.data() ?? [String : Any]())!
                }
            }
        }
    }
    
    // MARK: login/auth user
    
    func logIn(email: String, password: String, handler: @escaping AuthDataResultCallback) {
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
    }
    
    func logOut() throws {
        try Auth.auth().signOut()
    }
    
    func signUp(email: String, password: String, handler: @escaping AuthDataResultCallback) {
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
    }
    
    func resetPassword(email: String, handler: @escaping SendPasswordResetCallback) {
        Auth.auth().sendPasswordReset(withEmail: email, completion: handler)
    }
    
    // MARK: register flow
    
    func createUser(_ user: User) {
        self.currentUser  = user
        db.users.document(user.uid).setData(user.documentData)
    }
    
    func getProfile(user: String, handler: @escaping FIRDocumentSnapshotBlock) {
        db.users.document(user).getDocument(completion: handler)
    }
    
    func updateProfile(user: User?) {
        db.users.document(user.bound.uid).updateData(user.bound.documentData)
    }
    
    func createProject(_ project: Project) {
        db.projects.document("\(project.id)").setData(project.documentData)
    }
    
    private func updateProject(_ project: Project) {
        db.projects.document(String(project.id)).updateData(project.documentData)
    }
    
    func deleteProject(_ project: Project, com: @escaping (Error?) -> Void) {
        db.projects.document("\(project.id)").delete(completion: com)
    }
    
    func createTask(task: Task, project: Project) {
        db.tasks.document(String(describing: task.id)).setData(task.documentData)
    }
    
    private func updateTask(_ task: Task) {
        db.tasks.document(String(describing: task.id)).updateData(task.documentData)
    }
    
    func deleteTask(_ task: Task, com: @escaping (Error?) -> Void) {
        db.tasks.document(String(describing: task.id)).delete(completion: com)
    }
    
    func createComment(_ comment: Comment) {
        db.comments.document("\(comment.id)").setData(comment.documentData)
    }
    
    func deleteComment(_ comment: Comment, com: @escaping (Error?) -> Void) {
        db.comments.document("\(comment.id)").delete(completion: com)
    }
    
    func clearSession() {
        self.currentUser = nil
        self.session = nil
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

