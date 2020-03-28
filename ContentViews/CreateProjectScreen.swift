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
    
    @EnvironmentObject var session: SessionViewModel
    @Environment(\.presentationMode) var presentationMode

    @State private var name = ""
    @State private var tag = ""
    @State private var description = ""
    @State var isCorrectInput : Bool = false
    @State private var selection = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                LabelTextField(label: "Project name", placeHolder: "Fill in project name", text: self.$name)
                
                Text("Description").font(.headline).foregroundColor(Color.blue)
                MultilineTextField("Fill in project description", text: self.$description, onCommit: { })
                    .padding(.all)
                    .border(Color.black, width: 2)
                    .cornerRadius(5.0)
                    .padding(.all, 10)
                    
                LabelTextField(label: "Tags", placeHolder: "Fill in tags for this project", text: self.$tag)
                
                Toggle(isOn: $selection) {
                    Text("Open access")
                }.padding()
                
                Spacer()
            }
                .navigationBarItems(leading: CancelButton, trailing: DoneButton)
                .padding(.horizontal, 20)
        }
    }
    
    private var CancelButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
            self.clear()
        }) {
            Text("Cancel").foregroundColor(Color.blue)
        }
    }
    
    private var DoneButton: some View {
        Button(action: {
            self.isCorrectInput = self.isValidInput()
            
            if (self.isCorrectInput) {
                let project = Project(name: self.name, description: self.description)
                self.presentationMode.wrappedValue.dismiss()
                self.session.createProject(project: project)
                self.clear()
            } else {
                 print("not valid input")
            }
        }) {
            Text("Done").foregroundColor(Color.blue)
        }.showAlertError(title: "Error", text: "Incorrect input", isPresent: self.$isCorrectInput)
    }
    
    private func isValidInput() -> Bool {
        return !self.name.isEmpty && !self.description.isEmpty
    }
    
    private func clear() {
        self.name = ""
        self.description = ""
        self.tag = ""
        self.selection = false
    }
}


struct LabelTextField : View {
    
    var label: String
    var placeHolder: String
    
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label).font(.headline).foregroundColor(Color.blue)
            TextField(placeHolder, text: $text)
                .padding(.all)
                .border(Color.black, width: 2)
                .cornerRadius(5.0)
                .padding(.all, 10)
                
        }
    }
}
