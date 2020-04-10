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
    
    @EnvironmentObject var selections : Participants
    @State private var users = [User]()
    @State private var input: String = ""
        
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
                ScrollView {
                    ForEach(self.filterUsers(), id: \.email) { user in
                        ParticipantView(user: user,
                                        isSelected: self.selections.users.contains(user)).environmentObject(self.selections)
                            .padding(.horizontal, 10)
                            .padding(.top, 5)
                    }
                    Spacer()
                }
            }
        }
            .navigationBarTitle(Text("Search").bold(), displayMode: .inline)
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
    
    func filterUsers() -> [User] {
        return self.users.filter{ $0.email.contains(self.input.lowercased()) }
    }
}
