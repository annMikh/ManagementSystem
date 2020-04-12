//
//  TaskContentScreen.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 17.02.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation
import SwiftUI

struct TaskContentScreen : View {
    
    @State private var deadline = Date()
    @State private var alertInput = ""
    @State private var isClickedEdit = false
    @State private var editPermission = false
    @State private var isAddAssignee = false
    @State private var selection = false
    @State private var session = Session.shared
    @State private var pickPriority = 0
    @State private var pickStatus = 0
    @State private var name = ""
    @State private var description = ""
    private var participants = Set<String>()
    @State private var alertComment = AlertComment()
    
    //@ObservedObject var chosen = AssignedUser()
    @ObservedObject var store = CommentStore.shared
    @ObservedObject var taskStore : TaskStore
    
    private let status = Status.getAllCases()
    private let priority = Priority.getAllCases()
    
    init(_ t: Task, _ p: Project) {
        taskStore = TaskStore()
        taskStore.setTask(t)
        taskStore.setState(.View)
        participants = p.participants
    }
    
    var body : some View {
            ScrollView {
                Group {
                    LabelTextField(label: "Name", placeHolder: "enter task name", text: $name)
                    LabelTextField(label: "Description", placeHolder: "enter description", text: $description)
                    LabelTextField(label: "Assigned by", placeHolder: "", text: $taskStore.author.bound.email)
                        .disabled(true)
                        .foregroundColor(Color.black)
                }
                .foregroundColor(self.isClickedEdit ? Color.blue : Color.black)
                .disabled(!self.isClickedEdit)
                .padding(.horizontal, 10)
                .padding(.bottom, 10)
                
                VStack(alignment: .leading) {
                    Text("Status")
                        .font(.headline)
                        .foregroundColor(Color.primaryBlue)
                        .padding(.horizontal, 10)
                        .padding(.bottom, 10)
                    
                    Picker(selection: $pickStatus, label: Text("Status")) {
                          ForEach(0 ..< self.status.count) { index in
                              Text(self.status[index])
                                .foregroundColor(Color.black)
                                .tag(index)
                          }
                    }.pickerStyle(SegmentedPickerStyle())
                     .padding(.bottom, 10)
                     .padding(.horizontal, 5)
                     .disabled(!self.isClickedEdit)
                    
                    Text("Priority")
                        .font(.headline)
                        .foregroundColor(Color.primaryBlue)
                        .padding(.horizontal, 10)
                        .padding(.bottom, 10)
                    
                    Picker(selection: $pickPriority, label: Text("Priority")) {
                        ForEach(0 ..< self.priority.count) { index in
                            Text(self.priority[index]).foregroundColor(Color.black).tag(index)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.bottom, 10)
                    .padding(.horizontal, 5)
                    .disabled(!self.isClickedEdit)
                }
                
                HStack {
                    Text("Assigned user")
                        .font(.headline)
                        .foregroundColor(Color.primaryBlue)
                        .padding(.horizontal, 10)
                        .padding(.bottom, 10)
                    
                    Spacer()
                }
                
                NavigationLink(destination: SearchAssignee(chosen: taskStore.chosen, ids: self.participants),
                               isActive: $isAddAssignee) {
                    Button(action: {
                        if self.isClickedEdit {
                            self.isAddAssignee.toggle()
                        }
                    }) {
                        TextField("", text: $taskStore.chosen.user.email)
                            .disabled(true)
                            .foregroundColor(self.isClickedEdit ? Color.blue : Color.black)
                            .padding(.all)
                            .border(Color.black, width: 2)
                            .cornerRadius(5.0)
                            .padding(.all, 10)
                            .padding(.horizontal, 10).padding(.bottom, 10)
                    }
                }.disabled(!self.isClickedEdit)
                
                VStack(alignment: .leading) {
                    Text("Deadline")
                        .font(.headline)
                        .foregroundColor(Color.primaryBlue)
                        .padding(.horizontal, 10)
                        .padding(.bottom, 10)
                    
                    HStack {
                        Spacer()
                        DatePicker("",
                                   selection: $deadline,
                                   in: Date()...,
                                   displayedComponents: [.date, .hourAndMinute])
                            .labelsHidden()
                        Spacer()
                    }
                    
                    Toggle(isOn: $selection) {
                        Text("No deadline")
                    }.padding()
                    
                }
                .animation(.linear)
                .disabled(!self.isClickedEdit)
            
                HStack(alignment: .center, spacing: 10) {
                    Text("Comments")
                        .font(.headline)
                        .foregroundColor(.primaryBlue)
                        .padding(.leading, 10)
                    
                    Button(action: {
                        withAnimation {
                            self.alertComment.alert(
                                done: { _ in
                                    self.alertInput = self.alertComment.textField?.text ?? ""
                                    self.createComment()
                                }
                            )
                        }
                    }) {
                        Image(systemName: "text.bubble")
                            .resizable()
                            .foregroundColor(.black)
                            .frame(width: 20.0, height: 20.0)
                    }
                    Spacer()
                }
                if self.store.comments.isEmpty {
                    HStack {
                        Spacer()
                        Text("There aren't the comments\n for this task yet")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                            .padding()
                        Spacer()
                    }.padding()
                }
                else {
                    ForEach(self.store.comments, id: \.id) { comment in
                        CommentView(comment: comment)
                    }
                }
            }
            .showAlert(title: Constant.ErrorTitle, text: Constant.ErrorEditTitle, isPresent: $editPermission)
            .navigationBarTitle("Task")
            .navigationBarItems(trailing:
                Permission.toEditTask(task: self.taskStore.task) ? AnyView(self.EditButton) : AnyView(EmptyView())
            )
            .navigationViewStyle(StackNavigationViewStyle())
            .onAppear(perform: self.onAppear)
            .onDisappear {
                self.taskStore.task.status = Status.allCases[self.pickStatus]
                self.taskStore.task.priority = Priority.allCases[self.pickPriority]
            }
    }
    
    private func onAppear() {
        self.store.loadComments(task: taskStore.task)
        self.deadline = Formatter.getDateWithFormate(date: taskStore.task.deadline)
        self.name = taskStore.task.name
        self.description = taskStore.task.description
        self.pickStatus = Status.allCases.firstIndex(of: taskStore.task.status) ?? 0
        self.pickPriority = Priority.allCases.firstIndex(of: taskStore.task.priority) ?? 0
        self.selection = taskStore.task.deadline == Deadline.NoDeadline.description
    }

    
    private func updateTask() {
        self.session.updateTask(self.buildTask())
    }
    
    private var EditButton : some View {
          Button(action: {
              if Permission.toEditTask(task: self.taskStore.task) {
                  if self.isClickedEdit {
                      self.updateTask()
                  }
                  self.isClickedEdit.toggle()
              } else {
                  self.editPermission.toggle()
              }
          }){
              Image(systemName: self.isClickedEdit ? "pencil.slash" : "pencil")
                  .resizable()
                  .frame(width: 15.0, height: 15.0)
                  .padding(.all, CGFloat(5.0))
                  .overlay(
                      RoundedRectangle(cornerRadius: 4)
                          .stroke(Color.blue, lineWidth: 1)
                  )
            }
    }
    
    private func buildTask() -> Task {
        var t = Task(from: taskStore.task)
        t.name = name
        t.description = description
        t.assignedUser = taskStore.chosen.user.uid
        t.project = taskStore.task.project
        t.priority = Priority.allCases[pickPriority]
        t.status = Status.allCases[pickStatus]
        t.deadline = self.selection ?
            Deadline.NoDeadline.rawValue : Formatter.getStringWithFormate(date: deadline)
        return t
    }

    private func createComment() {
        if !alertInput.isEmpty {
            let comment = Comment(text: alertInput,
                                   author: session.currentUser.bound.uid,
                                   task: taskStore.task.id,
                                   date: Date(),
                                   id: "\(Date().hashValue)")
            session.createComment(comment)
            store.add(comment)
        }
    }

}
