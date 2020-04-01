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

    @State private var name = ""
    @State private var tag = ""
    @State private var description = ""
    @State private var isOpenProject : Bool = false
    @State private var isIncorrectInput : Bool = false
    
    private var pr : Project
    
    @EnvironmentObject var session: SessionViewModel
    @Environment(\.presentationMode) var presentationMode
    
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
                
                HStack {
                    Text("Participants").font(.headline).foregroundColor(Color.blue)
                    Button(action: {
                        // TODO add participants logic
                    }) {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 20.0, height: 20.0)
                            .padding(.horizontal, 10)
                    }
                }
                
                Toggle(isOn: $isOpenProject) {
                    Text("Open access")
                }.padding()
                
                Spacer()
            }
                .navigationBarItems(leading: CancelButton, trailing: DoneButton)
                .padding(.horizontal, 20)
        }
            .showAlert(title: Constant.ErrorTitle, text: Constant.ErrorInput, isPresent: self.$isIncorrectInput)
            .onAppear(perform: self.setFields)
            .onDisappear(perform: self.clear)
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
            self.isIncorrectInput = !Formatter.checkInput(self.name, self.description) || !Formatter.checkLength50(self.name)
            
            if !self.isIncorrectInput {
                let project = Project(name: self.name,
                                      description: self.description,
                                      creator: self.session.currentUser.bound.uid,
                                      tag: Formatter.handleTag(self.tag))
                project.participants.append(self.session.currentUser.bound.uid)
                self.presentationMode.wrappedValue.dismiss()
                self.session.createProject(project)
            }
        }) { Text("Done").foregroundColor(Color.blue) }
    }
    
    private func clear() {
        self.name.removeAll()
        self.description.removeAll()
        self.tag.removeAll()
        self.isOpenProject = false
    }
    
    private func setFields() {
        self.name = self.pr.name
        self.description = self.pr.description
        self.tag = self.pr.tag
        self.isOpenProject = self.pr.accessType.isOpen()
    }
}
