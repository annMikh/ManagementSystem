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
    
    @ObservedObject var task: Task
    @State private var isShowingAlert = false
    @State private var alertInput = ""
    
    private func getComments() -> Array<Comment> {
        return task.comments ?? Array<Comment>()
    }
    
    
    var body : some View {
        ZStack {
            ScrollView {
                VStack {
                    
                    Text("Assignee").font(.title).padding()
                    
                    HStack(alignment: .top) {
                            Image(systemName: "person")
                                .resizable()
                                .frame(width: 50.0, height: 50.0)
                                .padding(.horizontal, 10)

                            Spacer()
                            HStack {
                                Spacer()
                                Text(task.assignedUser.bound.getFullName()).padding()
                                Spacer()
                            }
                            .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.blue, lineWidth: 1))
                            Spacer()
                    }

                    Text("Description").font(.title).padding()
                    HStack(alignment: .top) {
                            Spacer()
                            Text(task.description.bound).padding()
                            Spacer()
                    }
                        .overlay(RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.blue, lineWidth: 1))

                    Text("Assigned by").font(.title).padding()
                    HStack {
                        Spacer()
                        Text(task.author.bound.getFullName())
                            .frame(minWidth: 200, maxWidth: 200)
                            .padding()
                        Spacer()
                    }
                        .overlay(RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.blue, lineWidth: 1))

                    HStack(alignment: .center, spacing: 8) {
                        Text("Comments").font(.title)

                        Button(action: {
                            withAnimation {
                                self.isShowingAlert.toggle()
                            }
                        }) {
                            Image(systemName: "text.bubble")
                                .resizable()
                                .frame(width: 20.0, height: 20.0)
                        }
                        Spacer()
                    }
                    
                    List {
                        ForEach(self.getComments(), id: \.hashValue) { comment in
                            CommentView(comment: comment)
                        }
                    }
                        
                }
            }
            
            TextFieldAlert(isShowing: $isShowingAlert, comment: alertInput)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}


struct CommentView : View {
    
    var comment: Comment
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Image(systemName: "person")
                    .resizable()
                    .frame(width: 50.0, height: 50.0)
                    .padding(.horizontal, 5)
                
                VStack(alignment: .leading) {
                    Text(comment.author.getFullName())
                        .font(.body)
                        .bold()
                        .padding(.horizontal, 10).padding(.top, 5)
                    
                    Text(DFormatter.getStringWithFormate(date: comment.date))
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 10)
                }
                Spacer()
            }.padding(.top, 5)
            
            Divider()
            Text(comment.text).font(.body).padding(.horizontal, 20).padding(.bottom, 5)
            
        }
            .overlay(RoundedRectangle(cornerRadius: 4)
            .stroke(Color.blue, lineWidth: 1))
    }
}
