//
//  ProfileScreen.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 18.03.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation
import SwiftUI

struct ProfileView : View {
    
    @State private var isClickedLogOut = false
    @State private var isClickedEdit = false

    private let roles : [(pos: Position, proj: String)] = [(Position.Designer, "project 1"), (Position.Developer, "project 2")]
    private var me : User? = SessionViewModel.me
    
    @State private var _lastName = "mikhaleva"
    @State private var _name = "anna"
    @State private var email = "admikhaleva@yandex.ru"
    
    private var name : String {
        get { return self._name }
        set { self._name = newValue }
    }
    
    private var lastName : String {
        get { return self._lastName }
        set { self._lastName = newValue }
    }

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

                        LabelTextField(label: "Email address", placeHolder: "", text: $email)
                            .disabled(true)
                            .disableAutocorrection(true)
                            .padding(.top, 20)
                    }

                    Group {
                     LabelTextField(label: "Your name", placeHolder: "enter your name", text: $_name)
                        .disabled(!self.isClickedEdit)
                        .padding()

                     LabelTextField(label: "Your lastname", placeHolder: "enter your lastname", text: $_lastName)
                        .disabled(!self.isClickedEdit)
                        .padding()
                    }
                
                    VStack(alignment: .leading) {
                        
                        Text("Roles in projects")
                            .font(.headline)
                            .foregroundColor(Color.blue)
                            .padding(.all, 10)
                            .padding()
                        
                        ForEach(0 ..< roles.count) { i in
                            PositionView(position: self.roles[i].pos, project: self.roles[i].proj)
                            if i != self.roles.count - 1 {
                                Divider()
                            }
                        }
                        Spacer(minLength: 35)
                        Divider()
                        
                        HStack(alignment: .center) {
                            Spacer()
                            Button(action: {
                                self.isClickedEdit = !self.isClickedEdit
                            }){
                                HStack(alignment: .center) {
                                    Image(systemName: nameForPencil())
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
                        
                        Divider()
                        
                        HStack {
                            Spacer()
                            Button(action: {
                                UserPreferences.setLogIn(false)
                                self.isClickedLogOut = true
                            }){
                                NavigationLink(destination: LoginView().navigationBarBackButtonHidden(true), isActive: $isClickedLogOut) {
                                    HStack(alignment: .center) {
                                        Image("logOut")
                                            .resizable()
                                            .frame(width: 15.0, height: 15.0)
                                            .foregroundColor(.red)
                                            .padding(.all, 4)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 2)
                                                    .stroke(Color.red, lineWidth: 1)
                                            )
                                        
                                        Text("Log Out").foregroundColor(.red)
                                    }
                                }.isDetailLink(false)
                            }
                            Spacer()
                        }
                    }
                
            }
            }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func nameForPencil() -> String {
        return self.isClickedEdit ? "pencil.slash" : "pencil"
    }
}


struct PositionView : View {
    
    let position : Position
    let project : String
    
    var body : some View {
            HStack {
                Image(systemName: Position.getImage(pos: position))
                    .resizable()
                    .frame(width: 20.0, height: 20.0)
                    .padding(.horizontal, 10)
                
                Text(String(describing: position)).bold().font(.body)
                Spacer()
                Text(project).foregroundColor(.gray).font(.body).padding(.trailing, 10)
            }
        
    }
}
