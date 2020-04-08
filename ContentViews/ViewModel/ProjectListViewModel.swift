//
//  ProjectListViewModel.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 01.04.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation
import Firebase
import SwiftUI
import FirebaseFirestore

final class ProjectListViewModel : ObservableObject {

    @Published var data = [Project]()
    private var db = Database.shared

    init(_ input: String?, isNeeded: Bool = true) {
        if (isNeeded){
            update(input)
        }
    }
    
    func update(_ input: String?) {
        if input != nil {
            self.db.loadProjects(com: self.handleData(snap:err:))
        } else if SessionViewModel.shared.session?.uid != nil {
            self.db.getProjects(me: SessionViewModel.shared.session, com: self.handleData(snap:err:))
        }
    }
    
    
    private func handleData(snap: QuerySnapshot?, err: Error?) {
        if err != nil{
            print((err?.localizedDescription)!)
            return
        }
        
        snap?.documents.forEach{
            let p = Project(document: $0)
            data.append(p!)
        }
    }
}
