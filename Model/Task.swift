//
//  Task.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 26.01.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

struct Task : Hashable, Codable, Identifiable {

    var author: String
    var date : Date
    var name : String
    var description : String
    var assignedUser: String
    var priority : Priority
    var status : Status
    var project: String
    var id: String
    var deadline: String
    
    var documentData: [String: Any] {
        return [
          "name": name,
          "description": description,
          "author": author,
          "date": date,
          "assignedUser": assignedUser,
          "priority": priority.rawValue,
          "status": status.rawValue,
          "project": project,
          "deadline": deadline,
          "id": id
        ]
      }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(author)
        hasher.combine(assignedUser)
        hasher.combine(date)
    }
    
    static func == (lhs: Task, rhs: Task) -> Bool {
        return lhs.author == rhs.author && lhs.assignedUser == rhs.assignedUser && lhs.date == rhs.date
    }
    
}


extension Task : DocumentSerializable {
    
    init(name: String = "",
         description: String = "",
         project: String = "",
         author: String = "",
         priority: Priority = Priority.low,
         status: Status = Status.New,
         date: Date = Date(),
         assignedUser: String = "",
         id: String = "",
         deadline: String = "") {
        
        self.init(
                author: author,
                date: date,
                name: name,
                description: description,
                assignedUser: assignedUser,
                priority: priority,
                status: status,
                project: project,
                id: id,
                deadline: deadline)
    }
    
    init(from: Task) {
        self.init()
        self.id = from.id
        self.date = from.date
        self.author = from.assignedUser
        self.project = from.project
    }
    
    private init?(documentID: String, dictionary: [String: Any]) {
      guard let name = dictionary["name"] as? String,
          let description = dictionary["description"] as? String,
          let project = dictionary["project"] as? String,
          let assignedUser = dictionary["assignedUser"] as? String,
          let date = dictionary["date"] as? Timestamp,
          let author = dictionary["author"] as? String,
          let status = dictionary["status"] as? String,
          let priority = dictionary["priority"] as? String,
          let deadline = dictionary["deadline"] as? String,
          let id = dictionary["id"] as? String else { return nil }

        self.init(name: name,
                description: description,
                project: project,
                author: author,
                priority: Priority(priority: priority),
                status: Status(status: status),
                date: date.dateValue(),
                assignedUser: assignedUser,
                id: id,
                deadline: deadline)
    }
    
    init?(document: QueryDocumentSnapshot) {
        self.init(documentID: document.documentID, dictionary: document.data())
    }
    
    init?(document: DocumentSnapshot) {
        guard let data = document.data() else { return nil }
        self.init(documentID: document.documentID, dictionary: data)
    }
}

