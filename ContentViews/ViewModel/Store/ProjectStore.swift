//
//  AppStore.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 05.04.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import FirebaseAuth

final class ProjectStore : ObservableObject {
    
    let objectWillChange = PassthroughSubject<(), Never>()
            
    @Published var project = Project()
    @Published var projects = [Project]()
    @Published var allProjects = [Project]()
    @Published var state: StateMachine.State = .None
    
    @Published var isLoad = false
    @Published var author : User?
    
    private var session = Session.shared
    private var database = Database.shared
    
    func update() {
        objectWillChange.send(())
    }
    
    func loadProjects(user: FirebaseAuth.UserInfo?) {
        database.getProjects(me: user) { (snap, error) in
            if error == nil {
                self.projects.removeAll()
                snap?.documents.forEach {
                    let p = Project(document: $0)!
                    self.projects.append(p)
                }
            } else {
                self.projects = [Project]()
            }
            self.update()
            self.isLoad = true
        }
    }
    
    func loadProjects() {
        self.database.loadProjects { (q, err) in
            if err == nil {
                self.allProjects.removeAll()
                q?.documents.forEach {
                    self.allProjects.append(Project(document: $0)!)
                }
            }
        }
    }
    
    func loadAuthor() {
        self.database.getUser(userId: self.project.creator) { (snap, err) in
            self.author = User(dictionary: snap?.data() ?? [String : Any]())
        }
    }
    
    func deleteProject(_ index: Int) -> Bool {
        let perm = Permission.toEditProject(project: self.projects[index])
        if perm {
            session.deleteProject(self.projects[index]) { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    self.update()
                    self.projects.remove(at: index)
                }
            }
        }
        return !perm
    }
    
    func move(source: IndexSet, destination: Int) {
        projects.move(fromOffsets: source, toOffset: destination)
    }
    
    func setState(state: StateMachine.State) {
        self.state = state
    }
    
    func setProject(_ project: Project) {
        self.project = project
        
        switch state {
        case .Add:
            createProject()
        case .Edit:
            updateProject()
        case .View: break
        case .None: break
        }
    }
    
    func indexOf() -> Int? {
        return projects.firstIndex(where: { $0.id == self.project.id })
    }
    
    func updateProject() {
        if let index = indexOf() {
            projects.remove(at: index)
            projects.insert(project, at: index)
            self.update()
        }
        session.updateProject(project)
    }
    
    func createProject() {
        session.createProject(self.project)
        projects.insert(self.project, at: 0)
    }
    
    func clear() {
        self.project = Project()
        self.projects = [Project]()
        self.allProjects = [Project]()
        self.state = .None
        self.isLoad = false
    }
}


enum StateMachine {
    
    enum State {
        case Edit, Add, View, None
    }
}
