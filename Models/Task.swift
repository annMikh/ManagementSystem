//
//  Task.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 26.01.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation

class Task : Hashable, Codable, ObservableObject  {
    
    static func builder(author: String, assignee: String) -> TaskBuilder {
        return TaskBuilder(author: author, assignee: assignee)
    }

    var author: String?
    var date = Date()
    var name : String?
    var description : String?
    var assignedUser: String?
    var priority = Priority.low
    var status = Status.New
    
    var deadline: Date?
    var comments : Array<Comment>?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(author)
        hasher.combine(assignedUser)
        hasher.combine(date)
    }
    
    static func == (lhs: Task, rhs: Task) -> Bool {
        return lhs.author == rhs.author && lhs.assignedUser == rhs.assignedUser && lhs.date == rhs.date
    }
    
}

class TaskBuilder {
    
    private var task = Task()
    
    init(author: String, assignee: String) {
        task.author = author
        task.assignedUser = assignee
    }
    
    func setAssignedUser(assignedUser: String) {
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

