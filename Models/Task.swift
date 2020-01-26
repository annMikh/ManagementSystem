//
//  Task.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 26.01.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation

class Task : Comparable {
    
    static func builder(author: User) -> TaskBuilder {
        return TaskBuilder(author: author)
    }

    var author: User?
    var date: Date?
    var name = ""
    var description = ""
    var assignedUser: User?
    var priority = Priority.low
    var status = Status.New
    
    var deadline: Date?
    
    
    static func < (lhs: Task, rhs: Task) -> Bool {
        return true
    }
    
    static func == (lhs: Task, rhs: Task) -> Bool {
        return true
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

class TaskDateFormatter {
    
    var defaultFormate = "MMMM-dd-yyyy HH:mm"
    
    private var formatter = DateFormatter()
    
    func getDataWithFormate(formate : String) -> Date {
        return formatter.date(from: formate) ?? Date()
    }
}
