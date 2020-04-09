//
//  ProjectScreen.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 02.02.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation
import SwiftUI
import Firebase

struct ProjectContentScreen : View {
    
    @State private var selectType = 0
    @State private var isSheetShown: Bool = false
    @State private var activeSheet : ActiveSheet = .add
    @State private var isParticipant: Bool = false
    
    private var priorities = Priority.getAllCases().map { $0.capitalizingFirstLetter() }
    private var project : Project
    
    @ObservedObject var store = ProjectStore.shared
    @ObservedObject var taskStore = TaskStore.shared
    @State var session = SessionViewModel.shared
    
    init(project: Project) {
        self.project = project
        self.store.setState(state: .View)
        self.store.setProject(project)
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
          VStack(alignment: .leading) {
            
              Picker("projects", selection: $selectType) {
                ForEach(0 ..< self.priorities.count) { index in
                    Text(self.priorities[index]).foregroundColor(Color.black).tag(index)
                }
              }.pickerStyle(SegmentedPickerStyle())
              
            List {
                ForEach(self.taskStore.tasks.filter{ $0.priority == Priority.allCases[self.selectType] },
                        id: \.id) { task in
                            TaskView(task: task).animation(.easeIn)
                  }
                  .onDelete(perform: delete)
                  .onMove(perform: move)
            }
            Spacer()
          }
        
          if self.showLabel() {
             EmptyListTextView(title: Constant.EmptyTasksTitle)
          }
            
            if self.isParticipant {
             FloatButton
          }
            
        }
        .navigationBarTitle(
            Text(self.store.project.name)
            .font(.largeTitle)
            .foregroundColor(.primary)
        )
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear(perform: self.onAppear)
    }
    
    private func delete(at offsets: IndexSet) {
        offsets.forEach(self.taskStore.delete(at:))
    }

    private func move(from source: IndexSet, to destination: Int) {
        self.taskStore.move(source: source, destination: destination)
    }
    
    private func showLabel() -> Bool {
        return self.taskStore
                    .tasks
                    .filter{ $0.priority == Priority.allCases[$selectType.wrappedValue] }
                    .isEmpty && self.taskStore.isLoad
    }
    
    private func onAppear() {
        self.isParticipant = Permission.isPerticipant(project: self.project)
        self.taskStore.loadTasks(self.store.project)
    }
    
    private var FloatButton : some View {
        FloatingButton(actionAdd: {
                           self.activeSheet = .add
                           self.isSheetShown.toggle()
                           self.taskStore.setState(.Add)
        },
                       actionEdit: {
                           self.activeSheet = .edit
                           self.isSheetShown.toggle()
                           self.store.setState(state: .Edit)
        })
            .padding()
            .sheet(isPresented: self.$isSheetShown) {
              if self.activeSheet == .add {
                  CreateTaskScreen(project: self.store.project)
              } else {
                  CreateProjectScreen()
              }
          }
    }
    
}
