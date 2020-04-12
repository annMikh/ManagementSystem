//
//  CreateTaskScreen.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 17.02.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation
import SwiftUI

struct CreateTaskScreen : View {
    
    @State var pickPriority = 0
    @State var pickStatus = 0
    @State var selection = false
    @State var name : String = ""
    @State var description : String = ""
    @State var selectedDate = Date()
    @State var text : String = ""
    @State var isIncorrectInput : Bool = false
    @State var isAddAssignee : Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var session = Session.shared
    @EnvironmentObject var store : TaskStore
    
    @ObservedObject var chosen = AssignedUser()
    @ObservedObject var storeProject : ProjectStore
    
    init(store: ProjectStore) {
        self.storeProject = store
    }
    
    private var priorities = Priority.getAllCases()
    private var statuses = Status.getAllCases()
    
    var body : some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    LabelTextField(label: "Task name", placeHolder: "Fill in task name", text: self.$name)
                        .padding(.top, 20)

                    Text("Description").font(.headline).foregroundColor(Color.primaryBlue)
                    MultilineTextField("Fill in task description", text: self.$description, onCommit: { })
                        .padding(.all)
                        .border(Color.black, width: 2)
                        .cornerRadius(5.0)
                        .padding(.horizontal, 10)

                    Text("Priority").font(.headline).foregroundColor(Color.primaryBlue)
                    Picker(selection: $pickPriority, label: Text("Priority")) {
                            ForEach(0 ..< self.priorities.count) { index in
                                Text(self.priorities[index]).foregroundColor(Color.black).tag(index)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Status").font(.headline).foregroundColor(Color.primaryBlue)
                        Picker(selection: $pickStatus, label: Text("Status")) {
                            ForEach(0 ..< self.statuses.count) { index in
                                Text(self.statuses[index]).foregroundColor(Color.black).tag(index)
                            }
                        }.pickerStyle(SegmentedPickerStyle())


                        Text("Assigned user").font(.headline).foregroundColor(Color.primaryBlue)

                        NavigationLink(destination: SearchAssignee(chosen: chosen,
                                                                   ids: self.storeProject.project.participants),
                                       isActive: $isAddAssignee) {
                            Button(action: { self.isAddAssignee.toggle() }) {
                                TextField("Choose the assigned user", text: $chosen.user.email)
                                    .disabled(true)
                                    .padding(.all)
                                    .border(Color.black, width: 2)
                                    .cornerRadius(5.0)
                                    .padding(.all, 10)
                            }
                        }
                    }

                    HStack(alignment: .center) {
                        Text("Deadline").font(.headline).foregroundColor(Color.primaryBlue)
                        Image("Calendar")
                            .resizable()
                            .frame(width: 20.0, height: 20.0)
                            .padding(.horizontal, 5)
                    }
                    DatePicker("", selection: $selectedDate,
                               in: Date()...,
                               displayedComponents: [.date, .hourAndMinute])
                            .labelsHidden()

                    Toggle(isOn: $selection) {
                        Text("No deadline")
                    }.padding()
                    
                }
                .navigationBarTitle("New task", displayMode: .inline)
                .navigationBarItems(trailing: DoneButton)
                .padding(.horizontal, 20)
            }.showAlert(title: Constant.ErrorTitle, text: Constant.ErrorInput, isPresent: self.$isIncorrectInput)
        }
    }
    
    private var CancelButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("Cancel").foregroundColor(Color.primaryBlue)
        }
    }
    
    private var DoneButton: some View {
        Button(action: {
            let task = self.buildTask()
            self.isIncorrectInput = !Formatter.checkInput(task.name,
                                                          task.description,
                                                          task.status,
                                                          task.priority,
                                                          task.date) || !Formatter.checkLength50(task.name)
            if !self.isIncorrectInput {
                self.store.setState(.Add)
                self.store.setTask(task)
                self.store.objectWillChange.send()
                self.presentationMode.wrappedValue.dismiss()
            }
        }) {
            Text("Done").foregroundColor(Color.primaryBlue)
        }
    }
    
    private func buildTask() -> Task {
        return Task(name: name, 
                        description: description,
                        project: storeProject.project.id,
                        author: session.currentUser.bound.uid,
                        priority: Priority.allCases[self.pickPriority],
                        status: Status.allCases[self.pickStatus],
                        date: Date(),
                        assignedUser: chosen.user.uid,
                        id: "\(Date().hashValue)",
                        deadline: selection ? Formatter.getStringWithFormate(date: selectedDate)
                            : Deadline.NoDeadline.description)
    }
}
