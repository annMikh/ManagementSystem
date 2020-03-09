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
    
    private var me = User(name: "anna", lastName: "mikhaleva", position: Position.Developer, id: 0)
    
    var body: some View {
          VStack(alignment: .leading) {
              Picker("projects", selection: $selectorIndex) {
                Text("In Progress").tag(0)
                Text("Assigned").tag(1)
                Text("Completed").tag(2)
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
          .navigationBarItems(leading: EditButton(), trailing: addTask)
    }
    
    private func getTasks() -> Array<Task> {
        return Array(project.tasks.first{ $0.key == me }?.value ?? [Task.builder().build(), Task.builder().build()])
    }
    
    private func delete(at offsets: IndexSet) {
        var tasks = project.tasks.first{ $0.key == me }?.value
        tasks?.remove(atOffsets: offsets)
    }

    private func move(from source: IndexSet, to destination: Int) {
        
    }
    
    private var addTask: some View {
           Button(action: {
               self.isPresentingModal = true
           }) {
               Image(systemName: "plus.circle.fill")
               .font(.title)
           }.sheet(isPresented: $isPresentingModal) {
               CreateTaskScreen()
           }
       }
}

struct TaskView: View {
    
    @ObservedObject var task: Task
    
    var body : some View {
        NavigationLink(destination: TaskContentScreen(task: task)) {
            HStack(alignment: .top) {
                Divider().background(Color.red)
            
                Image(systemName: "heart.circle.fill")
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
                        Text(CommonDateFormatter.getStringWithFormate(date: task.date))
                            .lineLimit(nil)
                            .font(.footnote)
                    }
                }
            }
            .frame(height: 50)
            .padding([.trailing, .top, .bottom])
        }
    }
}
