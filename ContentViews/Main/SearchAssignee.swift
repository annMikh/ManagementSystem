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
    
    @State private var input : String = ""
    @State var chosen : AssignedUser
    @State var ids: Set<String>
    
    @ObservedObject private var userStore = UserStore()
    @Environment(\.presentationMode) var presentationMode
    
    var body : some View {
        VStack(alignment: .center) {
            SearchBar(input: $input)
            
                 List {
                    ForEach(self.filterUsers(), id: \.uid) { user in
                        VStack(spacing: 5) {
                            HStack {
                                Text(user.email)
                                Spacer()
                                Text(user.position.rawValue)
                                    .foregroundColor(.gray)
                            }
                            Divider()
                        }
                        .padding(.horizontal, 10)
                        .padding(.top, 10)
                        .onTapGesture {
                            self.chosen.user = user
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                    
                    Spacer()
                }
        }.navigationBarTitle("Search assignee")
        .onAppear { self.userStore.loadUsers(ids: self.ids) }
    }
    
    func filterUsers() -> [User] {
        return input.isEmpty ? self.userStore.users :
            self.userStore.users.filter{
                $0.email.lowercased().contains(self.input.lowercased())
                || $0.name.lowercased().contains(self.input.lowercased())
                || $0.lastName.lowercased().contains(self.input.lowercased())
            }
    }
}
