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
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    @State private var isLogin: Bool = false
    @State private var isPresentingModal: Bool = false
    @State private var isForgetPassword: Bool = false
    
    @State var session = SessionViewModel.shared
    
    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableView.appearance().separatorColor = .clear
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
            MainView()
                .navigationBarTitle(
                 Text("Boards")
                     .font(.largeTitle)
                     .foregroundColor(.primary)
                )
                .navigationBarBackButtonHidden(true)
    }
    
    private var LoginContent : some View {
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
                SecureField("password", text: $password)
                    .padding()
            }
            .border(Color.black, width: 2)
            .padding(.all, 10)
            
            Button(action: { self.isForgetPassword.toggle() }) {
                HStack {
                    Spacer()
                    Text("Forget password?").foregroundColor(.blue).padding(.vertical, 5.0)
                    Spacer()
                }
            }.sheet(isPresented: $isForgetPassword) {
                ResetPasswordScreen()
            }
            
            NavigationLink(destination: Main, isActive: $isLogin) {
                Button(action: {
                    if Formatter.checkInput(self.email, self.password) {
                        self.session.logIn(email: self.email,
                                           password: self.password,
                                           handler: self.handleLogin(res:error:))
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
            }.isDetailLink(false)
            
            Spacer()
            
            Button(action: { self.isPresentingModal = true } ) {
                HStack {
                    Spacer()
                    Text("Haven't got an account?").foregroundColor(.blue).padding(.bottom, 20)
                    Spacer()
                }
            }
            .sheet(isPresented: $isPresentingModal) {
                RegisterView()
            }
        }
    }
    
    private func handleLogin(res: AuthDataResult?, error: Error?) {
        self.isLogin = error == nil
        UserPreferences.setLogIn(self.isLogin)
        if self.isLogin {
            clear()
            session.currentSession()
        }
    }
    
    private func clear() {
        email = ""
        password = ""
    }
    
    func isActive() -> Bool {
        return UserPreferences.isLogIn()
    }
}

