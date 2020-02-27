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
    @State var isLogIn: Bool = false
    @State var isPresentingModal: Bool = false
    
    @EnvironmentObject var session: FirebaseSession

    var body: some View {
    
        NavigationView {
            VStack(alignment: .leading) {
                    
                    Group {
                        TextField("email address", text: $email).padding()
                        SecureField("password", text: $password).padding()

                }
                .border(Color.black, width: 2)
                .padding(.all, 10)
                
                NavigationLink(destination: MainScreen(), isActive: $isLogIn) {
                    Button(action: {
                        if (!self.email.isEmpty && !self.password.isEmpty){
                            self.session.logIn(email: self.email, password: self.password) { (res, error) in
                                if error != nil {
                                    self.isLogIn = false
                                } else {
                                    self.isLogIn = true
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
                
                Button(action: {self.isPresentingModal = true } )
                {
                    HStack {
                        Spacer()
                        Text("Haven't got an account?").foregroundColor(.blue).padding(.bottom, 20)
                        Spacer()
                    }
                }.navigationBarTitle(
                    Text("Log In")
                        .font(.largeTitle)
                        .foregroundColor(.primary)
                )
                .sheet(isPresented: $isPresentingModal) {
                    RegisterView()
                }
        }
        }
    }
}

