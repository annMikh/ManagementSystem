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
    @State var position: Position = Position.Developer
    @State var password: String = ""
    
    @State private var pickerSelection = 0
    
    private var positions = Position.allCases.map {"\($0)"}
    
    init(){
        UITableView.appearance().backgroundColor = .clear
    }
        
    var body: some View {
    
            VStack(alignment: .leading) {
                    Text("Register")
                        .font(.largeTitle)
                        .foregroundColor(.primary)
                        .fixedSize()
                        .frame(width: 100, height: 50)
                        .padding(.horizontal, 20)
                    
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
                    
                
                Spacer()
            
                NextButton()
        }

    }
}

struct RegiesterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
