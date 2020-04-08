//
//  TaskStore.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 05.04.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation
import SwiftUI

final class TaskStore : ObservableObject {
    
    @Published var tasks = [Task]()
    @Published var task = Task()
    @Published var isLoad = false
    @Published var state : StateMachine.State = .None
    private init() {}
    
    private var session = SessionViewModel.shared
    private var database = Database.shared
    
    static let shared = TaskStore()
    
    
    func loadTasks(_ project: Project) {
        database.getTasks(project: project) { (snap, error) in
            self.tasks.removeAll()
            snap!.documents.forEach {
                let t = Task(document: $0)!
                self.tasks.append(t)
            }
            self.tasks.reverse()
            self.isLoad = true
        }
    }
    
    func delete(at: Int) {
        if Permission.toEditTask(task: self.tasks[at]) {
            self.session.deleteTask(self.tasks[at]) { err in
                if err == nil {
                    self.tasks.remove(at: at)
                }
            }
        }
    }
    
    func setTask(_ task: Task, _ project: Project) {
        self.task = task
        
        switch state {
        case .Add:
            createTask(project)
        case .Edit:
            updateTask(task)
        case .View: break
        case .None: break
        }
    }
    
    func createTask(_ project: Project) {
        session.createTask(task: self.task, project: project)
        tasks.insert(self.task, at: 0)
    }
    
    func indexOf() -> Int? {
        return tasks.firstIndex(of: self.task)
    }
    
    func updateTask(_ project: Task) {
        if let index = indexOf() {
            tasks[index] = task
        }
    }
    
    func move(source: IndexSet, destination: Int) {
         self.tasks.move(fromOffsets: source, toOffset: destination)
    }
    
    func setState(_ state: StateMachine.State) {
        self.state = state
    }
    
}
