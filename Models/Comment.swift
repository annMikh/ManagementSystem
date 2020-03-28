//
//  Comment.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 09.03.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation


class Comment : Hashable, Codable, ObservableObject {
    
    init(text: String, author: User, task: Task, date: Date) {
        self.text = text
        self.author = author
        self.date = date
        self.task = task
    }
    
    var text : String
    var author: User
    var date: Date
    var task: Task
    
    static func == (lhs: Comment, rhs: Comment) -> Bool {
        return lhs.task == rhs.task
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(text)
        hasher.combine(date)
        hasher.combine(task)
        hasher.combine(author)
    }
    
}
