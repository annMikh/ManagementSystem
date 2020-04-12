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
    @State private var userStore = UserStore()
    @State private var input: String = ""
        
    var body : some View {
        VStack {
            SearchBar(input: $input)
            
            if self.input.isEmpty {
                VStack(alignment: .center) {
                    Spacer()
                    Text(Constant.searchUser)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    Spacer()
                }
            } else {
                List {
                    ForEach(self.filterUsers(), id: \.uid) { user in
                        ParticipantView(user: user)
                            .environmentObject(self.selections)
                            .padding(.horizontal, CGFloat(10.0))
                            .padding(.top, CGFloat(5.0))

                    }
                    
                   Spacer()
                }
            }
        }
            .navigationBarTitle(Text("Search").bold(), displayMode: .inline)
            .onAppear { self.userStore.loadUsers() }
    }
    
    func filterUsers() -> [User] {
        return self.userStore.users.filter { $0.email.lowercased().contains(self.input.lowercased())
                     || $0.name.lowercased().contains(self.input.lowercased())
                     || $0.lastName.lowercased().contains(self.input.lowercased())
        }
    }
}
