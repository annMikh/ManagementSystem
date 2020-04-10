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
    @State private var activeSheet : StateMachine.State = .Add
    @State private var isParticipant: Bool = false
    
    private var priorities = Priority.getAllCases().map { $0.capitalizingFirstLetter() }
    
    @ObservedObject var store : ProjectStore
    @ObservedObject var taskStore = TaskStore()
    @State var session = Session.shared
    
    init(project: Project) {
        self.store = ProjectStore()
        store.setState(state: .View)
        store.setProject(project)
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
                ForEach(self.filterList()) { task in
                            TaskView(task: task, project: self.store.project).animation(.easeIn)
                  }
                  .onDelete(perform: delete)
                  .onMove(perform: move)
            }.id(UUID())
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
            Text(store.project.name)
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
    
    private func filterList() -> [Task] {
        return self.taskStore.tasks.filter{ $0.priority == Priority.allCases[self.selectType] }
    }
    private func showLabel() -> Bool {
        return self.taskStore
                    .tasks
                    .filter{ $0.priority == Priority.allCases[$selectType.wrappedValue] }
                    .isEmpty
    }
    
    private func onAppear() {
        self.isParticipant = Permission.isPerticipant(project: self.store.project)
        self.taskStore.loadTasks(self.store.project)
    }
    
    private var FloatButton : some View {
        FloatingButton(actionAdd: {
                           self.activeSheet = .Add
                           self.isSheetShown.toggle()
        },
                       actionEdit: {
                           self.activeSheet = .Edit
                           self.store.setState(state: self.activeSheet)
                           self.isSheetShown.toggle()
        })
            .padding()
            .sheet(isPresented: self.$isSheetShown) {
              if self.activeSheet == .Add {
                  CreateTaskScreen(project: self.store.project)
              } else {
                CreateProjectScreen()
                    .environmentObject(self.store)
              }
          }
    }
    
}
