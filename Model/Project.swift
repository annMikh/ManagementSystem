//
//  Project.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 26.01.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

struct Project : Hashable, Codable, Identifiable {
    
    var name: String
    var description: String
    var accessType: AccessType
    var creator: String
    var date: Date
    var id: String
    var tag : String
    
    var participants = Set<String>()
    var documentData: [String : Any] {
      return [
        "name": name,
        "description": description,
        "accessType": accessType.rawValue,
        "participants": Array(participants),
        "creator": creator,
        "date": date,
        "id": id,
        "tag": tag
      ]
    }
    
    static func == (lhs: Project, rhs: Project) -> Bool {
        return lhs.creator == rhs.creator && lhs.date == rhs.date && lhs.name == rhs.name
            && lhs.description == rhs.description && lhs.participants == rhs.participants
            && lhs.accessType == rhs.accessType && lhs.tag == rhs.tag
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(creator)
        hasher.combine(date)
    }
    
}


extension Project : DocumentSerializable  {
    
    init(name: String = "",
         description: String = "",
         accessType: AccessType = AccessType.open,
         creator: String = "",
         date: Date = Date(),
         tag: String = "",
         id: String = "") {
        self.init(
            name: name,
            description: description,
            accessType: accessType,
            creator: creator,
            date: date,
            id: id,
            tag: tag
        )
    }
    
    private init?(documentID: String, dictionary: [String: Any]) {
       guard let name = dictionary["name"] as? String,
           let description = dictionary["description"] as? String,
           let accessType = dictionary["accessType"] as? String,
           let creator = dictionary["creator"] as? String,
           let tag = dictionary["tag"] as? String,
           let date = dictionary["date"] as? Timestamp,
           let participants = dictionary["participants"] as? Array<String>,
           let id = dictionary["id"] as? String else { return nil }

         self.init(
             name: name,
             description: description,
             accessType: AccessType(mode: accessType),
             creator: creator,
             date: date.dateValue(),
             tag: tag,
             id: id
         )
        self.participants = Set(participants)
     }
    
    init?(document: QueryDocumentSnapshot) {
        self.init(documentID: document.documentID, dictionary: document.data())
    }
    
    init?(document: DocumentSnapshot) {
        guard let data = document.data() else { return nil }
        self.init(documentID: document.documentID, dictionary: data)
    }
}
