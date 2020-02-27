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
    @State var position: Position = Position.None
    @State var password: String = ""
    @State var isSignedUp: Bool = false
    
    @State private var pickerSelection = 0
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var session: FirebaseSession
    
    private var positions = Position.allCases.map {"\($0)"}
    
    init(){
        UITableView.appearance().backgroundColor = .clear
    }
        
    var body: some View {
    NavigationView {
                VStack(alignment: .leading) {
                        Group {
                            TextField("email address", text: $email).padding()
                            TextField("name", text: $name).padding()
                            
                            SecureField("password", text: $password).padding()
                    
                        }
                        .border(Color.black, width: 2)
                        .padding(.all, 10)
                
                        Form {
                            Section {
                                Picker(selection: $pickerSelection, label:
                                Text("position").foregroundColor(Color.black)) {
                                        ForEach(0 ..< self.positions.count) { index in
                                            Text(self.positions[index]).tag(index)
                                        }
                                }
                        }.padding()
                           
                    }
                
                    NavigationLink(destination: MainScreen(), isActive: $isSignedUp) {
                        Button(action: {
                            if (self.isValidInput()){
                                self.session.signUp(email: self.email, password: self.password) { (res, error) in
                                    if error != nil {
                                        self.isSignedUp = false
                                    } else {
                                        self.isSignedUp = true
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
                    
            }.navigationBarTitle(Text("Register"), displayMode: .inline)
                .navigationBarItems(leading: cancelButton, trailing: doneButton)
        }
    }
    
    private var cancelButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("Cancel").foregroundColor(Color.blue)
        }
    }
    
    private var doneButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("Done").foregroundColor(Color.blue)
        }
    }
    
    private func isValidInput() -> Bool {
        return !self.email.isEmpty && !self.password.isEmpty && !name.isEmpty
    }
}
