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
    
    @State var deadline = Date()
    @State private var alertInput = ""
    @State private var isClickedEdit = false
    @State private var editPermission = false
    @State private var isAddAssignee = false
    @State var selection = false
    @State private var session = Session.shared
    
    @State var pickPriority = 0
    @State var pickStatus = 0
    
    @State var name = ""
    @State var description = ""
    
    @ObservedObject var chosen = AssignedUser()
    
    private let status = Status.getAllCases()
    private let priority = Priority.getAllCases()
    
    @ObservedObject var store = CommentStore.shared
    @ObservedObject var taskStore : TaskStore
    
    init(_ t: Task, _ p: Project) {
        self.taskStore = TaskStore()
        taskStore.setTask(t, p)
        taskStore.setState(.View)
    }
    
    var body : some View {
            ScrollView {
              if Permission.toEditTask(task: self.taskStore.task) {
                    HStack {
                        Spacer()
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
                                .padding(.all, CGFloat(10.0))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color.blue, lineWidth: 1)
                                )
                        }
                    }.padding(.trailing, CGFloat(20.0))
                }
                Group {
                    LabelTextField(label: "Name", placeHolder: "enter task name", text: $name)
                    LabelTextField(label: "Description", placeHolder: "enter description", text: $description)
                    LabelTextField(label: "Assigned by", placeHolder: "enter user assigned by", text: $taskStore.author.bound.email)
                        .disabled(true)
                }
                .foregroundColor(self.isClickedEdit ? Color.blue : Color.black)
                .disabled(!self.isClickedEdit)
                .padding(.horizontal, 10).padding(.bottom, 10)
                
                VStack(alignment: .leading) {
                    Text("Status").font(.headline).foregroundColor(Color.primaryBlue)
                                .padding(.horizontal, 10).padding(.bottom, 10)
                    Picker(selection: $pickStatus, label: Text("Status")) {
                              ForEach(0 ..< self.status.count) { index in
                                  Text(self.status[index]).foregroundColor(Color.black).tag(index)
                              }
                        }.pickerStyle(SegmentedPickerStyle())
                        .padding(.bottom, 10)
                        .disabled(!self.isClickedEdit)
                    
                    Text("Priority").font(.headline).foregroundColor(Color.primaryBlue)
                                .padding(.horizontal, 10).padding(.bottom, 10)
                    Picker(selection: $pickPriority, label: Text("Priority")) {
                            ForEach(0 ..< self.priority.count) { index in
                                Text(self.priority[index]).foregroundColor(Color.black).tag(index)
                            }
                    }.pickerStyle(SegmentedPickerStyle())
                        .padding(.bottom, 10)
                        .disabled(!self.isClickedEdit)
                }
                
                HStack {
                    Text("Assigned user")
                        .font(.headline)
                        .foregroundColor(Color.primaryBlue)
                        .padding(.horizontal, 10).padding(.bottom, 10)
                    Spacer()
                }
                
                NavigationLink(destination: SearchAssignee(chosen: chosen), isActive: $isAddAssignee) {
                    Button(action: {
                        if self.isClickedEdit {
                            self.isAddAssignee.toggle()
                        }
                    }) {
                        TextField("Choose the assigned user", text: $chosen.user.email)
                            .disabled(true)
                            .foregroundColor(self.isClickedEdit ? Color.blue : Color.black)
                            .padding(.all)
                            .border(Color.black, width: 2)
                            .cornerRadius(5.0)
                            .padding(.all, 10)
                            .padding(.horizontal, 10).padding(.bottom, 10)
                    }
                }.disabled(!self.isClickedEdit)
                
                if $taskStore.task.deadline.wrappedValue != Deadline.NoDeadline.rawValue || self.isClickedEdit {
                    VStack(alignment: .leading) {
                        Text("Deadline")
                            .font(.headline)
                            .foregroundColor(Color.primaryBlue)
                            .padding(.horizontal, 10)
                            .padding(.bottom, 10)
                        HStack {
                            Spacer()
                            DatePicker("", selection: $deadline, in: Date()..., displayedComponents: [.date, .hourAndMinute])
                                .labelsHidden()
                            Spacer()
                        }
                        
                        Toggle(isOn: $selection) {
                            Text("No deadline")
                        }.padding()
                    }.animation(.linear)
                    .disabled(!self.isClickedEdit)
                } else {
                    LabelTextField(label: "Deadline", placeHolder: "enter deadline", text: $taskStore.task.deadline)
                            .padding(.horizontal, 10)
                            .padding(.bottom, 10)
                }
                
            
                HStack(alignment: .center, spacing: 10) {
                    Text("Comments")
                        .font(.headline)
                        .foregroundColor(.primaryBlue)
                        .padding(.leading, 10)
                    Button(action: {
                        withAnimation {
                            self.alert()
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
            .navigationViewStyle(StackNavigationViewStyle())
            .onAppear(perform: self.onAppear)
    }
    
    private func onAppear() {
        self.selection = taskStore.task.deadline == Deadline.NoDeadline.rawValue
        self.name = taskStore.task.name
        self.description = taskStore.task.description
        self.pickStatus = Status.allCases.firstIndex(of: taskStore.task.status)!
        self.pickPriority = Priority.allCases.firstIndex(of: taskStore.task.priority)!
        self.selection = taskStore.task.deadline == Deadline.NoDeadline.rawValue
        taskStore.loadAssigned(userId: taskStore.task.assignedUser) { (doc, err) in
            self.taskStore.assigned = User(dictionary: doc!.data() ?? [String : Any]())!
            if !self.chosen.isNotEmpty() {
                self.chosen.user = self.taskStore.assigned!
            }
        }
        self.taskStore.loadAuthor(userId: taskStore.task.author)
        self.store.loadComments(task: taskStore.task)
    }
    
    private func alert() {
        let alert = UIAlertController(title: "New Comment", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Enter your comment"
        }
        let textField = alert.textFields![0] as UITextField

        alert.addAction(UIAlertAction(title: "Cancel", style: .default) { _ in
            
        })
        alert.addAction(UIAlertAction(title: "Done", style: .default) { _ in
            self.alertInput = textField.text ?? ""
            self.createComment()
        })
        showAlert(alert: alert)
    }
    
    private func updateTask() {
        self.session.updateTask(self.buildTask())
    }
    
    private func buildTask() -> Task {
        var t = Task(from: taskStore.task)
        t.name = name
        t.description = description
        t.assignedUser = chosen.user.uid
        t.project = taskStore.task.project
        t.priority = Priority.allCases[pickPriority]
        t.status = Status.allCases[pickStatus]
        t.deadline = self.selection ?
            Deadline.NoDeadline.rawValue : Formatter.getStringWithFormate(date: deadline)
        return t
    }
    
    func showAlert(alert: UIAlertController) {
       if let controller = topMostViewController() {
           controller.present(alert, animated: true)
       }
    }
    
    private func topMostViewController() -> UIViewController? {
       guard let rootController = keyWindow()?.rootViewController else {
            return nil
       }
       return topMostViewController(for: rootController)
     }
    
    private func keyWindow() -> UIWindow? {
        return UIApplication
                    .shared.connectedScenes
                    .filter {$0.activationState == .foregroundActive}
                    .compactMap {$0 as? UIWindowScene}
                    .first?.windows.filter {$0.isKeyWindow}.first
    }
    
    private func topMostViewController(for controller: UIViewController) -> UIViewController {
        if let presentedController = controller.presentedViewController {
            
            return topMostViewController(for: presentedController)
            
        } else if let navigationController = controller as? UINavigationController {
            
            guard let topController = navigationController.topViewController else {
                return navigationController
            }
            return topMostViewController(for: topController)
            
        } else if let tabController = controller as? UITabBarController {
            
            guard let topController = tabController.selectedViewController else {
                return tabController
            }
            
            return topMostViewController(for: topController)
        }
        return controller
    }
    
    private func createComment() {
        if !alertInput.isEmpty {
            let comment = Comment(text: alertInput,
                                   author: session.currentUser.bound.uid,
                                   task: taskStore.task.id,
                                   date: Date(),
                                   id: "\(Date().hashValue)")
            self.session.createComment(comment)
            self.store.add(comment)
        }
    }

}
