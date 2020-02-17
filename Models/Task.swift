//
//  Task.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 26.01.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation

class Task : Comparable, Hashable, ObservableObject {
    
    static func builder(author: User) -> TaskBuilder {
        return TaskBuilder(author: author)
    }

    var author: User?
    var date = Date()
    var name = "example"
    var description = "task"
    var assignedUser: User?
    var priority = Priority.low
    var status = Status.New
    
    var deadline: Date?
    
    
    static func < (lhs: Task, rhs: Task) -> Bool {
        return lhs.date.compare(rhs.date).rawValue < 0
    }
    
    static func == (lhs: Task, rhs: Task) -> Bool {
        return lhs.author == rhs.author &&  lhs.name == rhs.name && lhs.assignedUser == rhs.assignedUser
            && lhs.description == rhs.description && lhs.priority == rhs.priority
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(description)
    }
    
}

class TaskBuilder {
    
    private var task = Task()
    
    init(author: User) {
        task.author = author
    }
    
    func setAssignedUser(assignedUser: User) {
        task.assignedUser = assignedUser
    }
    
    func setName(name: String) {
        task.name = name
    }
    
    func setDescription(description: String) {
        task.description = description
    }
    
    func setStatus(status: Status) {
        task.status = status
    }
    
    func setPriority(priority: Priority) {
        task.priority = priority
    }
    
    func setDeadline(deadline: Date) {
        task.deadline = deadline
    }

    func build() -> Task {
        task.date = Date()
        return task
    }
    
}

