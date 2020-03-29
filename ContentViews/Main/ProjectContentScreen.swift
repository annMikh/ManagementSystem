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
    
    @State var isSheetShown: Bool = false
    @State var activeSheet : ActiveSheet = .task
    var priorities = Priority.allCases.map { "\($0)".capitalizingFirstLetter() }
    
    private var me = SessionViewModel.me
    @EnvironmentObject var session: SessionViewModel
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
              VStack(alignment: .leading) {
                  Picker("projects", selection: $selectorIndex) {
                    ForEach(0 ..< self.priorities.count) { index in
                        Text(self.priorities[index]).foregroundColor(Color.black).tag(index)
                    }
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
            
              FloatingButton(actionAdd: {
                                 self.activeSheet = .task
                                 self.isSheetShown.toggle()
              },
                             actionEdit: {
                                 self.activeSheet = .project
                                 self.isSheetShown.toggle()
                                
              })
                  .padding()
                  .sheet(isPresented: self.$isSheetShown) {
                    
                    if self.activeSheet == .task {
                      CreateTaskScreen(project: self.project).environmentObject(self.session)
                    } else {
                      CreateProjectScreen(project: self.project).environmentObject(self.session)
                    }
                    
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

enum ActiveSheet {
   case task, project
}
