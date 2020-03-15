//
//  ContentView.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 25.01.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var isLogin: Bool = false
    @State var isPresentingModal: Bool = false
    
    @EnvironmentObject var session: SessionViewModel
    
    func isActive() -> Bool {
        return RegisterView.isSignedUp
    }

    var body: some View {
        AnyView({ () -> AnyView in
            if (self.isActive()) {
                return AnyView(MainView().environmentObject(session))
            } else {
                return AnyView(loginContent)
            }
            }())
    }
    
    private var loginContent : some View {
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
                
                NavigationLink(destination: MainView().environmentObject(session), isActive: $isLogin) {
                    Button(action: {
                        if (!self.email.isEmpty && !self.password.isEmpty){
                            self.session.logIn(email: self.email, password: self.password) { (res, error) in
                                if error != nil {
                                    self.isLogin = false
                                    UserDefaults.standard.set(false, forKey: "isLogin")
                                } else {
                                    UserDefaults.standard.set(true, forKey: "isLogin")
                                    self.isLogin = true
                                    self.email = ""
                                    self.password = ""
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
        }
    }
}

