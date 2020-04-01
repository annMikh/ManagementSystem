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
    
    var project: Project
    
    @State var pickPriority = 0
    @State var pickStatus = 0
    
    @State var selection = false
    @State var name : String = ""
    @State var description : String = ""
    @State var assignee : String = ""
    @State var selectedDate = Date()
    
    @State var isIncorrectInput : Bool = false
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var session: SessionViewModel
    
    private var priorities = Priority.allCases.map { "\($0)" }
    private var statuses = Status.allCases.map { "\($0)" }
    
    init(project: Project) {
        self.project = project
    }
    
    var body : some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    LabelTextField(label: "Task name", placeHolder: "Fill in task name", text: self.$name)
                    
                    Text("Description").font(.headline).foregroundColor(Color.blue)
                    MultilineTextField("Fill in task description", text: self.$description, onCommit: {
                        print("Final text: ")
                    })
                        .padding(.all)
                        .border(Color.black, width: 2)
                        .cornerRadius(5.0)
                        .padding(.horizontal, 10)
                                        
                    Text("Priority").font(.headline).foregroundColor(Color.blue)
                    Picker(selection: $pickPriority, label: Text("Priority")) {
                            ForEach(0 ..< self.priorities.count) { index in
                                Text(self.priorities[index]).foregroundColor(Color.black).tag(index)
                            }
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Status").font(.headline).foregroundColor(Color.blue)
                        Picker(selection: $pickStatus, label: Text("Status")) {
                            ForEach(0 ..< self.statuses.count) { index in
                                Text(self.statuses[index]).foregroundColor(Color.black).tag(index)
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                    }
                    
                    LabelTextField(label: "Assignee", placeHolder: "Fill in the assignee", text: self.$assignee)
                    
                    Text("Deadline").font(.headline).foregroundColor(Color.blue)
                    DatePicker("", selection: $selectedDate, in: ...Date(), displayedComponents: [.date, .hourAndMinute]).labelsHidden()
                    
                    Toggle(isOn: $selection) {
                        Text("No deadline")
                    }.padding()
                    
                }
                    .navigationBarItems(leading: cancelButton, trailing: doneButton)
                    .padding(.horizontal, 20)
            }
        }.showAlert(title: Constant.ErrorTitle, text: Constant.ErrorInput, isPresent: self.$isIncorrectInput)
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
            let task = self.buildTask()
            self.isIncorrectInput = !Formatter.checkInput(task.name, task.description, task.status, task.priority, task.date)
                                    || !Formatter.checkLength50(task.name.bound)
            if !self.isIncorrectInput {
                self.session.createTask(task: task, project: self.project)
                self.presentationMode.wrappedValue.dismiss()
            }
        }) {
            Text("Done").foregroundColor(Color.blue)
        }
    }
    
    private func buildTask() -> Task {
        let taskBuilder = TaskBuilder(author: self.session.currentUser?.uid ?? "",
                                      assignee: self.assignee)
        
        taskBuilder.setName(name: self.name)
        taskBuilder.setDescription(description: self.description)
        taskBuilder.setStatus(status: Status.New)
        taskBuilder.setPriority(priority: Priority.allCases[self.pickPriority])
        taskBuilder.setStatus(status: Status.allCases[self.pickStatus])

        return taskBuilder.build()
    }
}
