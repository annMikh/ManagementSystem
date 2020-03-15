//
//  RegisterScreen.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 25.01.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import SwiftUI

struct RegisterView: View {
    @State var email: String = ""
    @State var name: String = ""
    @State var lastName: String = ""
    @State var position: Position = Position.None
    @State var password: String = ""
    static var isSignedUp: Bool = false
    
    @State private var pickerSelection = 0
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var session: SessionViewModel
    
    private var positions = Position.allCases.map {"\($0)"}
    
    init(){
        UITableView.appearance().backgroundColor = .clear
        UITableView.appearance().separatorColor = .clear
    }
        
    var body: some View {
    NavigationView {
        VStack(alignment: .leading) {
                    Group {
                        TextField("email address", text: $email).padding()
                        TextField("name", text: $name).padding()
                        TextField("last name", text: $lastName).padding()
                        SecureField("password", text: $password).padding()
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
                
                    Button(action: {
                        if (self.isValidInput()) {
                            let user = User(name: self.name,
                                            lastName: self.lastName,
                                            position: Position.allCases[self.pickerSelection],
                                            email: self.email)
                            self.session.createUser(user: user)
                            self.session.signUp(email: self.email, password: self.password) { (res, error) in
                                RegisterView.self.isSignedUp = error != nil
                                self.presentationMode.wrappedValue.dismiss()
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
                    .padding(.bottom, 50)
                    

        }.navigationBarTitle(Text("Register").bold(), displayMode: .inline)
                .navigationBarItems(leading: cancelButton)
        }
    }
    
    private var cancelButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("Cancel").foregroundColor(Color.blue)
        }
    }
    
    private func isValidInput() -> Bool {
        return !self.email.isEmpty && !self.password.isEmpty && !name.isEmpty
    }
}
