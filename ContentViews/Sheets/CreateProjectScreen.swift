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
    @State private var isAddParticipants : Bool = false
    
    @ObservedObject var participants = Participants()
    
    @State var session = SessionViewModel.shared
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var store = ProjectStore.shared
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                LabelTextField(label: "Project name", placeHolder: "Fill in project name", text: self.$name)
                
                Text("Description").font(.headline).foregroundColor(Color.primaryBlue)
                MultilineTextField("Fill in project description", text: self.$description, onCommit: { })
                    .padding(.all)
                    .border(Color.black, width: 2)
                    .cornerRadius(5.0)
                    .padding(.all, 10)
                    
                HStack {
                    Text("Tag").font(.headline).foregroundColor(Color.primaryBlue)
                    Image("Tag")
                        .resizable()
                        .frame(width: 18.0, height: 18.0)
                        .padding(.horizontal, 5)
                }
                TextField("Fill in tags for this project", text: $tag)
                    .padding(.all)
                    .border(Color.black, width: 2)
                    .cornerRadius(5.0)
                    .padding(.all, 10)
                
                HStack {
                    Text("Participants").font(.headline).foregroundColor(Color.primaryBlue)
                    
                    NavigationLink(destination: SearchParticipants().environmentObject(self.participants),
                                   isActive: $isAddParticipants) {
                        Button(action: { self.isAddParticipants.toggle() }) {
                            Image(systemName: "plus")
                                .resizable()
                                .foregroundColor(Color.black)
                                .frame(width: 16.0, height: 16.0)
                                .padding(.horizontal, 5)
                        }
                    }
                }
                
                if self.participants.isNotEmpty() {
                        ForEach(self.participants.users, id: \.uid) { user in
                            HStack {
                                Text(user.email)
                                Spacer()
                                Text(user.position.rawValue).foregroundColor(.gray)
                            }.frame(maxHeight: 30)
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
            Text("Cancel").foregroundColor(Color.primaryBlue)
        }
    }
    
    private var DoneButton: some View {
        Button(action: {
            self.isIncorrectInput = !Formatter.checkInput(self.name, self.description)
                                    || !Formatter.checkLength50(self.name)
            
            if !self.isIncorrectInput {
                self.store.setProject(self.buildProject())
                self.presentationMode.wrappedValue.dismiss()
            }
            
        }) { Text("Done").foregroundColor(Color.primaryBlue) }
    }
    
    private func buildProject() -> Project {
        var project = Project(name: self.name,
                              description: self.description,
                              accessType: AccessType(mode: self.isOpenProject ? "open" : "close"),
                              creator: self.session.currentUser.bound.uid,
                              date: Date(),
                              tag: Formatter.handleTag(self.tag),
                              id: self.store.state == .Add ? Date().hashValue : self.store.project.id)
        project.participants.append(self.session.currentUser.bound.uid)
        participants.users.forEach{ project.participants.append($0.uid) }
        return project
    }
    
    private func clear() {
        self.name.removeAll()
        self.description.removeAll()
        self.tag.removeAll()
        self.isOpenProject = false
    }
    
    private func setFields() {
        if self.store.state == .Edit {
            self.name = self.store.project.name
            self.description = self.store.project.description
            self.tag = self.store.project.tag
            self.isOpenProject = self.store.project.accessType.isOpen()
            self.participants.fillParticipants(self.store.project)
        }
    }
}
