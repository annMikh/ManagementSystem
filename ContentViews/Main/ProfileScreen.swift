//
//  ProfileScreen.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 18.03.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation
import SwiftUI
import Firebase

struct ProfileView : View {
    
    @State private var isClickedLogOut = false
    @State private var isClickedEdit = false
    @State private var user : User?
    @State private var roles = [(pos: Position, proj: String)]()
    
    @EnvironmentObject var session : SessionViewModel
        
    var body : some View {
        ScrollView {
            VStack {
                HStack(alignment: .center, spacing: 30) {
                    Image(systemName: "person")
                        .resizable()
                        .frame(width: 50.0, height: 50.0)
                        .padding(.top, 20)
                        .padding(.leading, 20)

                    LabelTextField(label: "Email address", placeHolder: "", text: $session.currentUser.bound.email)
                        .disabled(true)
                        .disableAutocorrection(true)
                        .padding(.top, 20)
                }

                Group {
                    LabelTextField(label: "Your name", placeHolder: "enter your name", text: $session.currentUser.bound.name)
                    LabelTextField(label: "Your lastname", placeHolder: "enter your lastname", text: $session.currentUser.bound.lastName)
                }
                .foregroundColor(self.isClickedEdit ? Color.blue : Color.black)
                .disabled(!self.isClickedEdit)
                .padding()
                
                VStack(alignment: .leading) {
                    if self.roles.count > 0 {
                        Text("Roles in projects")
                            .font(.headline)
                            .foregroundColor(Color.blue)
                            .padding(.all, 10)
                            .padding()
                        
                        ForEach(0 ..< roles.count) { i in
                            PositionView(position: self.roles[i].pos, project: self.roles[i].proj).tag(i)
                            if i != self.roles.count - 1 {
                                Divider()
                            }
                        }
                    } else {
                        Spacer()
                    }
                    
                    Spacer()
                    Divider()
                    EditProfileButton
                    Divider()
                    LogOutButton
                }
            }
        }.navigationViewStyle(StackNavigationViewStyle())
         .onAppear { self.loadProfile(self.session.currentUser.bound) }
    }
    
    private func loadProfile(_ user: User) {
        self.session.currentSession()
        Database().getProjects(me: user) { (snap, error) in
            let result = Result {
                try snap!.documents.compactMap {
                    try $0.data(as: Project.self)
                }
            }
            switch result {
                case .success(let proj):
                    for p in proj {
                        // TODO get roles for every project
                        self.roles.append((pos: Position.None, proj: p.name))
                    }
                case .failure(let error):
                    print("Error decoding projects: \(error)")
            }
        }
    }

    
    private var LogOutButton : some View {
        HStack {
            Spacer()
            NavigationLink(destination: Login, isActive: $isClickedLogOut) {
                Button(action: {
                    do {
                        try self.session.logOut()
                        UserPreferences.setLogIn(false)
                        self.isClickedLogOut.toggle()
                    } catch {
                        print("log out error")
                    }
                }){
                    HStack(alignment: .center) {
                        Image("logOut")
                            .resizable()
                            .frame(width: 15.0, height: 15.0)
                            .foregroundColor(.red)
                            .padding(.all, 4)
                            .overlay(
                                RoundedRectangle(cornerRadius: CGFloat(2.0))
                                    .stroke(Color.red, lineWidth: CGFloat(1.0))
                            )

                        Text("Log Out").foregroundColor(.red)
                    }
                }
            }
            Spacer()
        }
    }
    
    private var Login : some View {
        LoginView()
            .navigationBarBackButtonHidden(true)
    }
    
    
    private var EditProfileButton : some View {
        HStack(alignment: .center) {
            Spacer()
            Button(action: {
                self.isClickedEdit = !self.isClickedEdit
            }){
                HStack(alignment: .center) {
                    Image(systemName: self.isClickedEdit ? "pencil.slash" : "pencil")
                        .resizable()
                        .frame(width: 15.0, height: 15.0)
                        .padding(.all, 4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.blue, lineWidth: 1)
                        )
                    Text("Edit profile")
                }
            }
            Spacer()
        }
    }
}
