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
    @State private var isOpenProject : Bool = false
    @State private var isIncorrectInput : Bool = false
    
    private var pr : Project
    
    init(project: Project = Project()) {
        self.pr = project
    }
    
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
                
                Toggle(isOn: $isOpenProject) {
                    Text("Open access")
                }.padding()
                
                Spacer()
            }
                .navigationBarItems(leading: CancelButton, trailing: DoneButton)
                .padding(.horizontal, 20)
        }.showAlertError(title: Constant.ErrorTitle, text: Constant.ErrorInput, isPresent: self.$isIncorrectInput)
        .onAppear{
            self.setFields()
        }.onDisappear {
            self.clear()
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
            self.isIncorrectInput = !self.isValidInput()
            
            if !self.isIncorrectInput {
                let project = Project(name: self.name, description: self.description)
                self.presentationMode.wrappedValue.dismiss()
                self.session.createProject(project: project)
            } else {
                 print("not valid input")
            }
        }) {
            Text("Done").foregroundColor(Color.blue)
        }
    }
    
    private func isValidInput() -> Bool {
        return !self.name.isEmpty && !self.description.isEmpty
    }
    
    private func clear() {
        self.name = ""
        self.description = ""
        self.tag = ""
        self.isOpenProject = false
    }
    
    private func setFields() {
        self.name = self.pr.name
        self.description = self.pr.description
        self.tag = ""
        self.isOpenProject = self.pr.accessType.isOpen()
    }
}
