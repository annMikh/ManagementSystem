//
//  TaskView.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 28.03.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation
import SwiftUI

struct TaskView : View {
    
    @State var task: Task
    @State var project: Project
    
    var body : some View {
        NavigationLink(destination: TaskContent) {
            VStack(spacing: 5) {
                HStack(alignment: .center, spacing: 3) {
                    Divider()
                        .background(Priority.getColor(priority: task.priority))
                        .frame(width: 3)
                
                    Image(systemName: "paperplane")
                        .resizable()
                        .frame(width: 50.0, height: 50.0)
                        .padding(.horizontal, 10)
                
                    
                    VStack(alignment: .leading) {
                        Text(task.name)
                            .lineLimit(1)
                            .font(.title)
                        
                        HStack(alignment: .firstTextBaseline) {
                            Text(task.description)
                                .lineLimit(1)
                                .font(.footnote)
                            Spacer()
                        }
                        
                        Text(String(describing: task.priority))
                            .lineLimit(1)
                            .font(.footnote)
                            .foregroundColor(Priority.getColor(priority: task.priority))
                        
                        HStack {
                            Spacer()
                            Text("")
                                .lineLimit(1)
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .frame(height: 50)
                .padding([.trailing, .top, .bottom])
                
                Divider()
            }
        }
    }
    
    var TaskContent : some View {
        TaskContentScreen(self.task, self.project)
            .navigationBarBackButtonHidden(false)
    }
}
