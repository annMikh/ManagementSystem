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
    }
    
    @ObservedObject var project: Project
    @State var selectorIndex = 0
    @State var isPresentingModal: Bool = false
    
    private var me = User(name: "anna", lastName: "mikhaleva", position: Position.Developer)
    
    var body: some View {
        NavigationView {
          VStack(alignment: .leading) {
              Picker("projects", selection: $selectorIndex) {
                Text("In Progress")
                Text("Assigned")
                Text("Completed")
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
              .foregroundColor(.primary))
            .navigationBarBackButtonHidden(false)
          .navigationBarItems(leading: EditButton(), trailing: addTask)
        }
    }
    
    private func getTasks() -> Array<Task> {
        return Array(project.tasks.first{ $0.key == me }?.value ?? [Task(), Task()])
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
        VStack {
            Text(task.name).foregroundColor(.white)
            Text(task.description).foregroundColor(.white)
        }
    }
}
