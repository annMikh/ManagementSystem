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
    
    @State var pickerSelection = 0
    @State var selection = false
    @State private static var name = ""
    @State private static var description = ""
    @State private static var assignee = ""
    private var selectedDate = Date()
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var session: SessionViewModel
    
    private var priorities = Priority.allCases.map { "\($0)" }
    
    var taskBinding = Binding<String>(get: { name }, set: { name = $0 } )
    var descriptionBinding = Binding<String>(get: { description }, set: { description = $0 } )
    var asigneeBinding = Binding<String>(get: { assignee }, set: { assignee = $0 } )
    
    init(project: Project){
        self.project = project
    }
    
    var body : some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    LabelTextField(label: "Task name", placeHolder: "Fill in task name", text: self.taskBinding)
                    
                    Text("Description").font(.headline).foregroundColor(Color.blue)
                    MultilineTextField("Fill in task description", text: self.descriptionBinding, onCommit: {
                        print("Final text: ")
                    })
                        .padding(.all)
                        .border(Color.gray, width: 2)
                        .cornerRadius(5.0)
                        .padding(.horizontal, 10)
                        
                    Text("Priority").font(.headline).foregroundColor(Color.blue)
                    
                    Form {
                        Picker(selection: $pickerSelection, label:
                        Text("Priority").foregroundColor(Color.black)) {
                                ForEach(0 ..< self.priorities.count) { index in
                                    Text(self.priorities[index]).foregroundColor(Color.black).tag(index)
                                }
                        }
//                        DatePicker(selectedDate) {
//                            Text("Deadline")
//                        }
                    }
                    
                    LabelTextField(label: "Assignee", placeHolder: "Fill in the assignee", text: self.taskBinding)
                    
                    Toggle(isOn: $selection) {
                        Text("No deadline")
                    }.padding()
                    
                }
                    .navigationBarItems(leading: cancelButton, trailing: doneButton)
                    .padding(.horizontal, 20)
            }
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
            let task = self.buildTask()
            
            if self.isTaskValid(task) {
                self.session.createTask(task: task, project: self.project)
                self.presentationMode.wrappedValue.dismiss()
            }
        }) {
            Text("Done").foregroundColor(Color.blue)
        }
    }
    
    private func buildTask() -> Task {
        let taskBuilder = TaskBuilder(author: SessionViewModel.me!,
                                      assignee: User(name: "name", lastName: "surname", position: Position.Designer, email: "mail")
        )
        
        taskBuilder.setName(name: CreateTaskScreen.name)
        taskBuilder.setDescription(description: CreateTaskScreen.description)
        taskBuilder.setStatus(status: Status.New)
        taskBuilder.setPriority(priority: Priority.allCases[self.pickerSelection])

        return taskBuilder.build()
    }
    
    private func isTaskValid(_ task: Task) -> Bool {
        return !(task.name?.isEmpty ?? false) && !(task.description?.isEmpty ?? false) &&
            task.deadline != nil && !(task.comments?.isEmpty ?? false) && task.author != nil  && task.assignedUser != nil
    }
}
