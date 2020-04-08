//
//  AppStore.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 05.04.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation
import SwiftUI
import FirebaseAuth

final class ProjectStore : ObservableObject {
    
    static let shared = ProjectStore()
    
    @Published var project = Project()
    @Published var projects = [Project]()
    @Published var allProjects = [Project]()
    @Published var state: StateMachine.State = .None
    
    @Published var isLoad = false
    
    private var session = SessionViewModel.shared
    private var database = Database.shared
    
    private init() {}
    
    func loadProjects(user: FirebaseAuth.UserInfo?) {
        database.getProjects(me: user) { (snap, error) in
            if error == nil {
                self.projects.removeAll()
                snap?.documents.forEach {
                    self.projects.append(Project(document: $0)!)
                }
                self.projects.reverse()
            } else {
                self.projects = [Project]()
            }
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
                self.allProjects.reverse()
            }
        }
    }
    
    func deleteProject(_ index: Int) {
        if Permission.toEditProject(project: self.projects[index]) {
            session.deleteProject(self.projects[index]) { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    self.projects.remove(at: index)
                }
            }
        }
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
        return projects.firstIndex(of: self.project)
    }
    
    func updateProject() {
        if let index = indexOf() {
            projects[index] = project
        }
    }
    
    func createProject() {
        session.createProject(self.project)
        projects.insert(self.project, at: 0)
    }
}


enum StateMachine {
    
    enum State {
        case Edit, Add, View, None
    }
}
