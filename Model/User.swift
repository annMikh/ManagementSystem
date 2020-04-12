//
//  User.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 26.01.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

struct User : Hashable, Codable {
    
    var name: String
    var lastName: String
    var email: String
    var position: Position
    var uid: String
    
    var documentID: String {
      return uid
    }
    
    var documentData: [String : Any] {
        return [
          "uid": uid,
          "name": name,
          "email": email,
          "lastName": lastName,
          "position": position.rawValue,
        ]
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.email == rhs.email && lhs.uid == rhs.uid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(email)
        hasher.combine(uid)
    }
    
    func getFullName() -> String {
        return "\(name) \(lastName)"
    }

}

extension User : DocumentSerializable {
    
    init(user: FirebaseAuth.UserInfo) {
        let u = user.displayName?.split(separator: " ")
        self.init(name: String(u?[0] ?? ""),
                  lastName: String(u?[1] ?? ""),
                  email: user.email ?? "",
                  position: Position(position: ""),
                  uid: user.uid)
    }
    
    public init?(dictionary: [String: Any]) {
      guard let name = dictionary["name"] as? String,
        let uid = dictionary["uid"] as? String,
        let lastName = dictionary["lastName"] as? String,
        let email = dictionary["email"] as? String,
        let position = dictionary["position"] as? String else { return nil }

        self.init(name: name,
                  lastName: lastName,
                  email: email,
                  position: Position(position: position),
                  uid: uid)
    }
    
    private init?(documentID: String, dictionary: [String : Any]) {
      guard (dictionary["uid"] as? String) != nil else { return nil }
      self.init(dictionary: dictionary)
    }
    
    
    init?(document: QueryDocumentSnapshot) {
        self.init(documentID: document.documentID, dictionary: document.data())
    }
    
    init?(document: DocumentSnapshot) {
        guard let data = document.data() else { return nil }
        self.init(documentID: document.documentID, dictionary: data)
    }
}
