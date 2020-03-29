//
//  ContentView.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 25.01.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import SwiftUI
import Firebase

struct LoginView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var isLogin: Bool = false
    @State var isPresentingModal: Bool = false
    
    @EnvironmentObject var session: SessionViewModel
    
    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableView.appearance().separatorColor = .clear
    }
    
    func isActive() -> Bool {
        return RegisterView.isSignedUp
    }

    var body: some View {
        AnyView({ () -> AnyView in
            if (self.isActive()) {
                return AnyView(Main)
            } else {
                return AnyView(LoginContent)
            }
            }())
    }
    
    private var Main : some View {
         VStack {
            MainView()
                .environmentObject(session)
                .navigationBarTitle(
                 Text("Boards")
                     .font(.largeTitle)
                     .foregroundColor(.primary)
                )
                .navigationBarBackButtonHidden(true)
        }
    }
    
    private var LoginContent : some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                    
                    Text("Log In")
                        .font(.largeTitle)
                        .foregroundColor(.primary)
                        .bold()
                        .padding(.top, 40).padding(.horizontal, 20)
                        
                    Group {
                        TextField("email address", text: $email)
                            .autocapitalization(.none)
                            .padding()
                        SecureField("password", text: $password).padding()
                    }
                    .border(Color.black, width: 2)
                    .padding(.all, 10)
                    
                    NavigationLink(destination:mainContent, isActive: $isLogin) {
                        Button(action: {
                            print("blya")
                            if (!self.email.isEmpty && !self.password.isEmpty){
                                self.session.logIn(email: self.email, password: self.password) { (res, error) in
                                    self.isLogin = error == nil
                                    UserPreferences.setLogIn(self.isLogin)
                                    if self.isLogin {
                                        self.clear()
                                        self.session.saveUserData(response: res?.user)
                                    }
                                }
                            }
                        }) {
                            HStack {
                                Spacer()
                                Text("NEXT")
                                    .font(.headline)
                                    .foregroundColor(Color.white)
                                Spacer()
                            }
                        }
                        .padding(.vertical, 10.0)
                        .background(Color.blue)
                        .cornerRadius(6.0)
                        .padding(.horizontal, 50)
                    }
                    
                    Spacer()
                    
                    Button(action: { self.isPresentingModal = true } )
                    {
                        HStack {
                            Spacer()
                            Text("Haven't got an account?").foregroundColor(.blue).padding(.bottom, 20)
                            Spacer()
                        }
                    }
                    .sheet(isPresented: $isPresentingModal) {
                        RegisterView().environmentObject(self.session)
                    }
                    Spacer()
            }
        }
    }
    
    private func clear() {
        self.email = ""
        self.password = ""
    }
    
    private var mainContent : some View {
         MainView()
            .navigationBarTitle(
             Text("Boards")
                 .font(.largeTitle)
                 .foregroundColor(.primary)
            )
            .navigationBarBackButtonHidden(true)
            .environmentObject(session)
    }
}

