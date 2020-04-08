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
    
    @State var task: Task
    @State private var alertInput = ""
    @State private var isClickedEdit = false
    @State private var session = SessionViewModel.shared
    
    @ObservedObject var store = CommentStore.shared

    var body : some View {
            ScrollView {
                    HStack {
                        Spacer()
                        Button(action: {
                            self.isClickedEdit = !self.isClickedEdit
                        }){
                            Image(systemName: self.isClickedEdit ? "pencil.slash" : "pencil")
                                .resizable()
                                .frame(width: 15.0, height: 15.0)
                                .padding(.all, 10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color.blue, lineWidth: 1)
                                )
                        }
                    }.padding(.trailing, 20)
                    
                    Group {
                        LabelTextField(label: "Name", placeHolder: "enter task name", text: $task.name)
                        LabelTextField(label: "Description", placeHolder: "enter description", text: $task.description)
                        LabelTextField(label: "Deadline", placeHolder: "enter deadline", text: $task.deadline)
                        LabelTextField(label: "Assigned user", placeHolder: "enter assigned user", text: $store.assigned.bound.email)
                        LabelTextField(label: "Assigned by", placeHolder: "enter user assigned by", text: $store.author.bound.email)
                    }
                    .foregroundColor(self.isClickedEdit ? Color.blue : Color.black)
                    .disabled(!self.isClickedEdit)
                    .padding()
            
                    HStack(alignment: .center, spacing: 10) {
                        Text("Comments").font(.headline).foregroundColor(Color.black).padding(.leading, 10)
                        Button(action: {
                            withAnimation {
                                self.alert()
                            }
                        }) {
                            Image(systemName: "text.bubble")
                                .resizable()
                                .frame(width: 20.0, height: 20.0)
                        }
                        Spacer()
                    }
                    
                    ForEach(self.store.comments, id: \.id) { comment in
                        CommentView(comment: comment)
                    }
            }
            .navigationBarTitle("Task")
            .navigationViewStyle(StackNavigationViewStyle())
            .onAppear(perform: self.onAppear)
    }
    
    private func onAppear()  {
        self.store.loadAssigned(userId: self.task.assignedUser)
        self.store.loadAuthor(userId: self.task.author)
        self.store.loadComments(task: self.task)
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
        let comment = Comment(text: alertInput,
                               author: session.currentUser.bound.uid,
                               task: task.id,
                               date: Date(),
                               id: Date().hashValue)
        self.session.createComment(comment)
    }

}
