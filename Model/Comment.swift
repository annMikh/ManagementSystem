//
//  Comment.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 09.03.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

struct Comment : Codable, Hashable {

    var text : String
    var author: String
    var date: Date
    var task: Int
    var id: Int
    
    var documentData: [String : Any] {
      return [
        "text": text,
        "author": author,
        "date": date,
        "task": task,
        "id": id
      ]
    }

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


extension Comment : DocumentSerializable {
    
    init(text: String = "", author: String = "", task: Int = 0, date: Date = Date(), id: Int = 0) {
        self.init(text: text,
                  author: author,
                  date: date,
                  task: task,
                  id: id)
    }
    
    private init?(documentID: String, dictionary: [String: Any]) {
      guard let text = dictionary["text"] as? String,
          let author = dictionary["author"] as? String,
          let date = dictionary["date"] as? Timestamp,
          let task = dictionary["task"] as? Int,
          let id = dictionary["id"] as? Int else { return nil }

      self.init(text: text,
                author: author,
                task: task,
                date: date.dateValue(),
                id: id)
    }
    
    init?(document: QueryDocumentSnapshot) {
        self.init(documentID: document.documentID, dictionary: document.data())
    }
    
    init?(document: DocumentSnapshot) {
        guard let data = document.data() else { return nil }
        self.init(documentID: document.documentID, dictionary: data)
    }
}
