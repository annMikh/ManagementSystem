//
//  SearchAssignee.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 05.04.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation
import SwiftUI
import FirebaseFirestore

struct SearchAssignee : View {
    
    @State var input : String = ""
    @State var users = [User]()
    @State var chosen : AssignedUser
    
    @Environment(\.presentationMode) var presentationMode
    
    var body : some View {
        VStack(alignment: .center) {
            SearchBar(input: $input)
            
            if self.input.isEmpty {
                VStack(alignment: .center) {
                    Spacer()
                    Text("Please, enter the info \nto search the user")
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    Spacer()
                }
            } else {
                VStack(alignment: .leading) {
                    ForEach(self.getUsers(), id: \.email) { user in
                        HStack {
                            Text(user.email)
                            Spacer()
                            Text(user.position.rawValue).foregroundColor(.gray)
                        }.padding(.horizontal, 10)
                        .padding(.top, 10)
                        .onTapGesture {
                                self.chosen.user = user
                                self.presentationMode.wrappedValue.dismiss()
                        }
                        
                    }
                    Spacer()
                }
            }
        }.navigationBarTitle("Search assignee")
            .onAppear{
                Database.shared.getUsers(com: self.loadUsers)
            }
    }
    
    func loadUsers(snap: QuerySnapshot?, err: Error?) {
        if err != nil {
            print((err?.localizedDescription)!)
            return
        }
        snap?.documents.forEach{
            let u = User(document: $0)!
            users.append(u)
        }
    }
    
    func getUsers() -> [User] {
        return self.users.filter{ $0.email.contains(self.input.lowercased()) ||
            $0.name.contains(self.input.lowercased()) || $0.lastName.contains(self.input.lowercased())
        }
    }
}
