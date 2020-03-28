//
//  ProjectScreen.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 02.02.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation
import SwiftUI

struct ProjectContentScreen : View {
    
    init(project: Project){
        self.project = project
        UISegmentedControl.appearance().selectedSegmentTintColor = .blue
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.blue], for: .normal)
    }
    
    @ObservedObject var project: Project
    @State var selectorIndex = 0
    
    @State var isPresentingAdd: Bool = false
    @State var isPresentingEdit: Bool = false
    
    private var me = SessionViewModel.me
    @EnvironmentObject var session: SessionViewModel
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
              VStack(alignment: .leading) {
                  Picker("projects", selection: $selectorIndex) {
                    Text("Low").tag(0)
                    Text("Medium").tag(1)
                    Text("High").tag(2)
                    Text("Critical").tag(3)
                  }
                    .pickerStyle(SegmentedPickerStyle())
                  
                List {
                    ForEach(getTasks(), id: \.self) { task in
                        TaskView(task: task)
                      }
                      .onDelete(perform: delete)
                      .onMove(perform: move)
                }
                  Spacer()
              }
            
              FloatingButton(actionAdd: { self.isPresentingAdd.toggle() },
                 actionEdit: { self.isPresentingEdit.toggle() })
                  .padding()
                  .sheet(isPresented: self.$isPresentingAdd){
                      CreateTaskScreen(project: self.project).environmentObject(self.session)
              }
            }
            .navigationBarTitle(
              Text(project.name)
                .font(.largeTitle)
                .foregroundColor(.primary)
            )
              .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func getTasks() -> [Task] {
        return project.tasks.filter{ $0.priority == Priority.allCases[$selectorIndex.wrappedValue] }
    }
    
    private func delete(at offsets: IndexSet) {
        var tasks = project.tasks
        tasks.remove(atOffsets: offsets)
    }

    private func move(from source: IndexSet, to destination: Int) {
        
    }
}

struct TaskView : View {
    
    @ObservedObject var task: Task
    
    var body : some View {
        NavigationLink(destination: TaskContent) {
            VStack {
                HStack(alignment: .center, spacing: 3) {
                    Divider().background(Priority.getColor(priority: task.priority))
                
                    Image(systemName: "paperplane")
                        .resizable()
                        .frame(width: 50.0, height: 50.0)
                        .padding(.horizontal, 10)
                
                    
                    VStack(alignment: .leading) {
                        Text(task.name.bound)
                            .lineLimit(1)
                            .font(.title)
                        
                        HStack(alignment: .firstTextBaseline) {
                            Text(task.description.bound)
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
                            Text(DFormatter.getStringWithFormate(date: task.deadline))
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
        TaskContentScreen(task: task)
            .navigationBarTitle(task.name.bound)
            .navigationBarBackButtonHidden(false)
    }
}
