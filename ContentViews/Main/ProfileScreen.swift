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
import FirebaseAuth

struct ProfileView : View {
    
    @State private var isClickedLogOut = false
    @State private var isClickedEdit = false
    @State private var user : User?
    @State private var roles = [(acc: AccessType, proj: String)]()
    
    @State var pickerSelection = 0
    private var positions = Position.getAllCases()

    @State var session = Session.shared
        
    var body : some View {
        ScrollView {
            VStack(alignment: .leading) {
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
                    Text("Position").font(.headline).foregroundColor(Color.primaryBlue).padding()
                    HStack {
                        Spacer()
                        Picker(selection: $pickerSelection, label: Text("")) {
                                ForEach(0 ..< self.positions.count) { index in
                                    Text(self.positions[index])
                                        .foregroundColor(self.isClickedEdit ? Color.blue : Color.black)
                                        .tag(index)
                                }
                            }.pickerStyle(DefaultPickerStyle())
                        .frame(maxHeight: 70)
                        .disabled(!self.isClickedEdit)
                        .labelsHidden()
                        Spacer()
                    }
                }
            
                Spacer(minLength: 100)
                
                VStack(alignment: .leading) {
                    Divider()
                    EditProfileButton
                    Divider()
                    LogOutButton
                }.padding()
            }
        }.navigationViewStyle(StackNavigationViewStyle())
            .onAppear { self.loadProfile(self.session.session) }
    }
    
    private func loadProfile(_ user: FirebaseAuth.UserInfo?) {
        Database.shared.getProjects(me: user) { (snap, error) in
            if error == nil {
                snap?.documents.forEach{
                    let pr = Project(document: $0)
                    self.roles.append((acc: pr?.accessType ?? .close, proj: pr?.name ?? ""))
                }
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
                        self.session.clearSession()
                        self.isClickedLogOut.toggle()
                    } catch {
                        print("log out error") //todo show alert
                    }
                }){
                    HStack(alignment: .center) {
                        Image("logOut")
                            .resizable()
                            .frame(width: 15.0, height: 15.0)
                            .foregroundColor(.fadedRed)
                            .padding(.all, 4)
                            .overlay(
                                RoundedRectangle(cornerRadius: CGFloat(2.0))
                                    .stroke(Color.fadedRed, lineWidth: CGFloat(1.0))
                            )

                        Text("Log Out").foregroundColor(.fadedRed)
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
                if !self.isClickedEdit {
                    self.session.currentUser?.position =
                        Position(position: self.positions[self.pickerSelection])
                    self.session.updateProfile(user: self.session.currentUser)
                }
            }){
                HStack(alignment: .center) {
                    Image(systemName: self.isClickedEdit ? "pencil.slash" : "pencil")
                        .resizable()
                        .foregroundColor(.blue)
                        .frame(width: 15.0, height: 15.0)
                        .padding(.all, 4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.blue, lineWidth: 1)
                        )
                    Text("Edit profile").foregroundColor(.blue)
                }
            }
            Spacer()
        }
    }
}
