//
//  Task.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 26.01.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation

class Task : Hashable, Codable, ObservableObject  {
    
    static func builder(author: User = User(user: SessionViewModel.me), assignee: User) -> TaskBuilder {
        return TaskBuilder(author: author, assignee: assignee)
    }

    var author: User?
    var date = Date()
    var name : String?
    var description : String?
    var assignedUser: User?
    var priority = Priority.low
    var status = Status.New
    
    var deadline: Date?
    var comments : Array<Comment>?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(description)
    }
    
    static func == (lhs: Task, rhs: Task) -> Bool {
        return lhs.author == rhs.author &&  lhs.name == rhs.name && lhs.assignedUser == rhs.assignedUser
            && lhs.description == rhs.description && lhs.priority == rhs.priority
    }
    
}

class TaskBuilder {
    
    private var task = Task()
    
    init(author: User, assignee: User) {
        task.author = author
        task.assignedUser = assignee
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

