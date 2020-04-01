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
    
    var session: Firebase.User?
    var currentUser : User?
    
    func currentSession() {
        self.session = Auth.auth().currentUser
        self.saveUserData(response: session)
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if self.session != user {
                self.saveUserData(response: user)
            }
        }
    }
    
    func saveUserData(response: Firebase.User?) {
        self.session = response
        self.currentUser = User(name: "",
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
    
    func createUser(_ user: User) {
        self.refUsers.document(user.uid).setData([
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
    
    private static let db = Firestore.firestore()
    private let refProjects = db.collection(SessionViewModel.PROJECTS)
    private let refTasks = db.collection(SessionViewModel.TASKS)
    private let refUsers = db.collection(SessionViewModel.USERS)
}
