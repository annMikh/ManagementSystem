//
//  RegisterScreen.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 25.01.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import SwiftUI
import Firebase

struct RegisterView: View {
    
    @State private var email: String = ""
    @State private var name: String = ""
    @State private var lastName: String = ""
    @State private var position: Position = Position.None
    @State private var password: String = ""
    
    @State static var isSignedUp: Bool = false
    @State private var isIncorrectInput: Bool = false
    @State private var pickerSelection = 0
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var session: SessionViewModel
    
    private var positions = Position.allCases.map {"\($0)"}
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Group {
                    TextField("email address", text: $email)
                        .autocapitalization(.none)
                        .padding()
                    TextField("name", text: $name)
                        .padding()
                    TextField("last name", text: $lastName)
                        .padding()
                    SecureField("password", text: $password)
                        .autocapitalization(.none)
                        .padding()
                }
                .border(Color.black, width: 2)
                .padding(.all, 15)
                
                Text("Choose position").font(.headline).bold().foregroundColor(Color.black).padding(.horizontal, 10)
                        Form {
                            Picker(selection: $pickerSelection, label:
                            Text("position").foregroundColor(Color.black)) {
                                    ForEach(0 ..< self.positions.count) { index in
                                        Text(self.positions[index]).tag(index)
                                    }
                            }
                        }
                        .padding(.horizontal, 10)
                        
                Spacer()
                    
                Button(action: self.handleResponse) {
                            HStack {
                                Spacer()
                                Text("NEXT")
                                    .font(.headline)
                                    .foregroundColor(Color.white)
                                Spacer()
                            }
                        }.showAlertError(title: Constant.ErrorTitle, text: Constant.ErrorRegister, isPresent: $isIncorrectInput)
                        .padding(.vertical, 10.0)
                        .background(Color.blue)
                        .cornerRadius(6.0)
                        .padding(.horizontal, 50)
                        .padding(.bottom, 50)
                        

            }.navigationBarTitle(Text("Register").bold(), displayMode: .inline)
             .navigationBarItems(leading: CancelButton)
        }
    }
    
    private var CancelButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("Cancel").foregroundColor(Color.blue)
        }
    }
    
    private func handleResponse() {
        self.isIncorrectInput = !Formatter.checkInput(self.email,
                                                    self.name,
                                                    self.lastName,
                                                    Position.allCases[self.pickerSelection])
        if (!self.isIncorrectInput) {
            let user = User(name: self.name,
                            lastName: self.lastName,
                            position: Position.allCases[self.pickerSelection],
                            email: self.email,
                            uid: "")
            
            self.session.signUp(email: self.email, password: self.password) { (res, error) in
                RegisterView.isSignedUp = res != nil
                if RegisterView.isSignedUp {
                    self.session.saveUserData(response: res?.user)
                    self.session.createUser(user)
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
    
}
