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
    
    @State var pickerSelection = 0
    @State var selection = false
    @State private var selectedDate = Date()
    @Environment(\.presentationMode) var presentationMode
    
    private var task : TaskBuilder = Task.builder()
    private var priorities = Priority.allCases.map { "\($0)" }
    
    init(){
        UITableView.appearance().backgroundColor = .clear
        UITableView.appearance().separatorColor = .clear
    }
    
    var body : some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    LabelTextField(label: "Task name", placeHolder: "Fill in task name")
                    
                    Text("Description").font(.headline).foregroundColor(Color.blue)
                    MultilineTextField("Fill in task description", text: CreateProjectScreen.testBinding, onCommit: {
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
                    }
//                        DatePicker("", selection: $selectedDate, label:  Text("Deadline").font(.headline).foregroundColor(Color.blue))
                    
                    
                    LabelTextField(label: "Assignee", placeHolder: "Fill in the assignee")
                    
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
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("Done").foregroundColor(Color.blue)
        }
    }
}
