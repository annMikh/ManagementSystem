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
    @Environment(\.presentationMode) var presentationMode
    
    private var task : TaskBuilder = Task.builder()
    private var priorities = Priority.allCases.map { "\($0)" }
    
    var body : some View {
        NavigationView {
                VStack(alignment: .leading) {
                    LabelTextField(label: "Task name", placeHolder: "Fill in task name")
                    
                    Text("Description").font(.headline).foregroundColor(Color.white)
                    MultilineTextField("Fill in task description", text: CreateProjectScreen.testBinding, onCommit: {
                        print("Final text: ")
                    })
                        .padding(.all)
                        .border(Color.gray, width: 2)
                        .cornerRadius(5.0)
                        .padding(.all, 10)
                        
                    Form {
                        Section {
                                Picker(selection: $pickerSelection, label:
                                Text("Priority").foregroundColor(Color.black)) {
                                        ForEach(0 ..< self.priorities.count) { index in
                                            Text(self.priorities[index]).tag(index)
                                        }
                                }
                        }.padding()
                    }
                    
                    LabelTextField(label: "Assignee", placeHolder: "Fill in the assignee")
                    
                    Spacer()
                    
                    LabelTextField(label: "Deadline", placeHolder: "Fill in the deadline")
                        
                    Spacer()
                    
                    Toggle(isOn: $selection) {
                        Text("No deadline")
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
