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
import PartialSheet

struct ProjectContentScreen : View {
    
    @State private var selectType = 0
    @State private var isSheetShown: Bool = false
    @State private var activeSheet : StateMachine.State = .Add
    @State private var isParticipant: Bool = false
    @State private var isInfoClicked: Bool = false
    @State private var session = Session.shared
    
    @ObservedObject var store : ProjectStore
    @ObservedObject var taskStore = TaskStore()
    
    private var priorities = Priority.getAllCases().map { $0.capitalizingFirstLetter() }
    
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
                ForEach(self.filterList(), id: \.self) { task in
                    TaskView(task: task, project: self.store.project).tag(task.id)
                }
                .onDelete(perform: delete)
                .onMove(perform: move)
                
            }.animation(.default)
            
            Spacer()
          }
        
          if self.showLabel() {
             EmptyListTextView(title: Constant.EmptyTasksTitle).animation(.easeInOut)
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
        .navigationBarItems(trailing: InfoButton)
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear(perform: self.onAppear)
        .partialSheet(presented: $isInfoClicked) { InfoSheet(project: self.store.project, author: self.store.author) }
    }
    
    private func delete(at offsets: IndexSet) {
        offsets.forEach(self.taskStore.delete(at:))
    }

    private func move(from source: IndexSet, to destination: Int) {
        taskStore.move(source: source, destination: destination)
    }
    
    private func filterList() -> [Task] {
        return taskStore.tasks.filter{ $0.priority == Priority.allCases[selectType] }
    }
    private func showLabel() -> Bool {
        return self.taskStore
                    .tasks
                    .filter{ $0.priority == Priority.allCases[$selectType.wrappedValue] }
                    .isEmpty
    }
    
    private func onAppear() {
        store.loadAuthor()
        isParticipant = Permission.isPerticipant(project: store.project)
        taskStore.loadTasks(store.project)
    }
    
    private func add() {
        activeSheet = .Add
        isSheetShown.toggle()
    }
    
    private func edit() {
        activeSheet = .Edit
        store.setState(state: .Edit)
        isSheetShown.toggle()
    }
    
    private var InfoButton : some View {
        Button(action: { self.isInfoClicked.toggle() }) {
            Image(systemName: "info.circle")
            .resizable()
            .foregroundColor(Color.blue)
            .frame(width: 20.0, height: 20.0)
        }
    }
    
    private var FloatButton : some View {
        FloatingButton(actionAdd: self.add,
                       actionEdit: self.edit)
            .padding()
            .sheet(isPresented: self.$isSheetShown) {
                  if self.activeSheet == .Add {
                    CreateTaskScreen(store: self.store).environmentObject(self.taskStore)
                  } else {
                    CreateProjectScreen().environmentObject(self.store)
                  }
            }
    }
    
}
