//
//  Comment.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 09.03.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation


class Comment : Hashable, Codable, ObservableObject {
    
    init(text: String, author: User, date: Date = Date()) {
        self.text = text
        self.author = author
        self.date = date
    }
    
    var text : String
    var author: User
    var date: Date
    var id: Int?
    
    static func == (lhs: Comment, rhs: Comment) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(text)
        hasher.combine(id)
        hasher.combine(date)
    }
    
}
