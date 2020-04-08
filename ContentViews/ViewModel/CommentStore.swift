//
//  CommentStore.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 05.04.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation
import SwiftUI

final class CommentStore : ObservableObject {
    
    @Published var comments = [Comment]()
    @Published var author : User?
    @Published var assigned : User?
    
    static let shared = CommentStore()
    
    private let session = SessionViewModel.shared
    private let database = Database.shared
    
    func loadComments(task : Task) {
        database.getComments(task: task) { (snap, error) in
            if error == nil {
                self.comments.removeAll()
                snap!.documents.forEach{
                    self.comments.append(Comment(document: $0)!)
                }
                self.comments.reverse()
                print(self.comments.count)
            }
        }
    }
    
    func loadAuthor(userId: String) {
        database.getUser(userId: userId) { (doc, err) in
            self.author = User(dictionary: doc!.data() ?? [String : Any]())!
        }
    }
    
    func loadAssigned(userId: String) {
        database.getUser(userId: userId) { (doc, err) in
            self.assigned = User(dictionary: doc!.data() ?? [String : Any]())!
        }
    }
}
