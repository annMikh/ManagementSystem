//
//  CreateProjectScreen.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 26.01.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation
import SwiftUI

struct CreateProjectScreen : View {
    
    @State private var selection = true
    @State private var input = ""
    @State static private var inputValue = ""
    @Environment(\.presentationMode) var presentationMode
    
    private let types = ["open", "close"]
    
    static var testBinding = Binding<String>(get: { inputValue }, set: {
            print("New value: \($0)")
            inputValue = $0 } )
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                LabelTextField(label: "Project name", placeHolder: "Fill in project name")
                
                Text("Description").font(.headline).foregroundColor(Color.white)
                MultilineTextField("Fill in project description", text: CreateProjectScreen.testBinding, onCommit: {
                    print("Final text: ")
                })
                    .padding(.all)
                    .border(Color.gray, width: 2)
                    .cornerRadius(5.0)
                    .padding(.all, 10)
                    
                Text("Tags")
                
                Toggle(isOn: $selection) {
                    Text("Open access")
                }.padding()
                
                Spacer()
            }.navigationBarItems(leading: cancelButton, trailing: doneButton)
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
    
}


struct LabelTextField : View {
    
    var label: String
    var placeHolder: String
    
    @State var value: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label).font(.headline).foregroundColor(Color.white)
            TextField(placeHolder, text: $value)
                .padding(.all)
                .border(Color.gray, width: 2)
                .cornerRadius(5.0)
                .padding(.all, 10)
                
        }
    }
}

struct CreateProjectView_Previews: PreviewProvider {
    static var previews: some View {
        CreateProjectScreen()
    }
}
