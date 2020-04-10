//
//  TaskStore.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 05.04.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import FirebaseFirestore

final class TaskStore : ObservableObject {
    
    let objectWillChange = PassthroughSubject<(), Never>()
            
    @Published var tasks = [Task]()
    @Published var task = Task()
    @Published var isLoad = false
    @Published var state : StateMachine.State = .None
    
    @Published var author : User?
    @Published var assigned : User?
    
    private var session = Session.shared
    private var database = Database.shared
    
    func update(item: Task) {
       defer {
           objectWillChange.send(())
       }
    }
    
    func update(item: User?) {
       defer {
           objectWillChange.send(())
       }
    }
    
    func loadTasks(_ project: Project) {
        database.getTasks(project: project) { (snap, error) in
            if error != nil {
                return
            }
            self.tasks.removeAll()
            snap!.documents.forEach {
                let t = Task(document: $0)!
                self.tasks.append(t)
                self.update(item: t)
            }
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
        return tasks.firstIndex(where: { $0.id == self.task.id })
    }
    
    func updateTask(_ task: Task) {
        if let index = indexOf() {
            tasks.remove(at: index)
            tasks.insert(task, at: index)
            self.update(item: task)
        }
        session.updateTask(task)
    }
    
    func move(source: IndexSet, destination: Int) {
         self.tasks.move(fromOffsets: source, toOffset: destination)
    }
    
    func setState(_ state: StateMachine.State) {
        self.state = state
    }
    
    func loadAuthor(userId: String) {
        database.getUser(userId: userId) { (doc, err) in
            self.author = User(dictionary: doc!.data() ?? [String : Any]())!
            self.update(item: self.author)
        }
    }
    
    func loadAssigned(userId: String, com: @escaping FIRDocumentSnapshotBlock) {
        database.getUser(userId: userId, com: com)
    }
    
    func clear() {
        self.task = Task()
        self.tasks = [Task]()
        self.assigned = nil
        self.author = nil
        self.state = .None
    }
}
