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
    @State var isPresentingModal: Bool = false
    
    private var me = SessionViewModel.me
    @EnvironmentObject var session: SessionViewModel
    
    var body: some View {
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
    
    var addTask: some View {
           Button(action: {
               self.isPresentingModal = true
           }) {
               Image(systemName: "plus")
               .font(.title)
           }.sheet(isPresented: $isPresentingModal) {
                CreateTaskScreen().environmentObject(self.session)
           }
    }
}

struct TaskView : View {
    
    @ObservedObject var task: Task
    
    var body : some View {
        NavigationLink(destination: taskContent) {
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
                        Text(CommonDateFormatter.getStringWithFormate(date: task.deadline))
                            .lineLimit(1)
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                }
            }
            .frame(height: 50)
            .padding([.trailing, .top, .bottom])
        }
    }
    
    var taskContent : some View {
        TaskContentScreen(task: task)
            .navigationBarTitle(task.name.bound)
            .navigationBarBackButtonHidden(false)
    }
}
