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
    @State private var isRegisterClicked: Bool = false
    @State private var isForgetPasswordClicked: Bool = false
    @State private var isIncorrectInput: Bool = false
    @State private var session = Session.shared
    
    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableView.appearance().separatorColor = .clear
    }

    var body: some View {
        AnyView({ () -> AnyView in
            if UserPreferences.isLogIn() {
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
            
            ForgetPasswordButton
            NextButton
            
            Spacer()
            
            RegisterButton
            
        }.showAlert(title: Constant.ErrorTitle, text: Constant.ErrorInput, isPresent: $isIncorrectInput)
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
    
    /// Button for registration
    private var RegisterButton : some View {
        Button(action: { self.isRegisterClicked.toggle() }) {
            HStack {
                Spacer()
                Text("Haven't got an account?")
                    .foregroundColor(.primaryBlue)
                    .padding(.bottom, 20)
                Spacer()
            }
        }
        .sheet(isPresented: $isRegisterClicked) { RegisterView() }
    }
    
    /// Button for resetting password with email address
    private var ForgetPasswordButton : some View {
        Button(action: { self.isForgetPasswordClicked.toggle() }) {
            HStack {
                Spacer()
                Text("Forget password?")
                    .foregroundColor(.primaryBlue)
                    .padding(.vertical, 5.0)
                Spacer()
            }
        }.sheet(isPresented: $isForgetPasswordClicked) { ResetPasswordScreen() }
    }
    
    /// Button for trying to login
    private var NextButton : some View {
        NavigationLink(destination: Main, isActive: $isLogin) {
            Button(action: {
                self.isIncorrectInput = !Formatter.checkInput(self.email, self.password)
                if !self.isIncorrectInput {
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
            .background(Color.primaryBlue)
            .cornerRadius(6.0)
            .padding(.horizontal, 50)
            
        }.isDetailLink(false)
    }
}

