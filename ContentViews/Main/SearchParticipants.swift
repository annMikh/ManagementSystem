//
//  SearchParticipants.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 02.04.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation
import SwiftUI
import Firebase

struct SearchParticipants : View {
    
    @State var input: String = ""
    @State var selections: Participants
    @State var users = [User]()
        
    var body : some View {
        VStack {
            SearchBar(input: $input)
            
            if self.input.isEmpty {
                VStack(alignment: .center) {
                    Spacer()
                    Text("Please, enter the word \nto search the users by email")
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    Spacer()
                }
            } else {
                List {
                    ForEach(self.getUsers(), id: \.email) { user in
                        ParticipantView(user: user, input: self.input, selectedItems: self.$selections.users)
                            .onTapGesture {
                                if self.selections.users.contains(user) {
                                    self.selections.users.remove(user)
                                } else {
                                    self.selections.users.insert(user)
                                }
                        }
                    }
                }
            }
        }
            .navigationBarTitle(Text("Search").bold(), displayMode: .inline)
            .navigationBarItems(trailing: EditButton())
            .onAppear {
                Database.shared.getUsers(com: self.loadUsers)
            }
    }
    
    func loadUsers(snap: QuerySnapshot?, err: Error?) {
        if err != nil{
            print((err?.localizedDescription)!)
            return
        }
        snap?.documents.forEach{
            let u = User(document: $0)!
            users.append(u)
        }
    }
    
    func getUsers() -> [User] {
        return self.users.filter{ $0.email.contains(self.input.lowercased()) }
    }
}
