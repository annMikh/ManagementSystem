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
    
    @State private var tasks = [Task]()
    @State private var selectType = 0
    @State private var isSheetShown: Bool = false
    @State private var activeSheet : ActiveSheet = .add
    
    private var project: Project
    private var priorities = Priority.allCases.map { "\($0)".capitalizingFirstLetter() }
    
    @EnvironmentObject var session: SessionViewModel
    
    init(project: Project){
        self.project = project
        
        UISegmentedControl.appearance().selectedSegmentTintColor = .blue
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.blue], for: .normal)
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
                ForEach(self.tasks.filter{ $0.priority == Priority.allCases[$selectType.wrappedValue] }, id: \.self) { task in
                    TaskView(task: task)
                  }
                  .onDelete(perform: delete)
                  .onMove(perform: move)
            }
            Spacer()
          }
        
          if self.tasks.isEmpty {
             EmptyListTextView(title: Constant.EmptyTasksTitle)
          }
            
          FloatingButton(actionAdd: {
                             self.activeSheet = .add
                             self.isSheetShown.toggle()
          },
                         actionEdit: {
                             self.activeSheet = .edit
                             self.isSheetShown.toggle()
                            
          })
              .padding()
              .sheet(isPresented: self.$isSheetShown) {
                if self.activeSheet == .add {
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
        .onAppear(perform: self.onAppear)
    }
    
    private func delete(at offsets: IndexSet) {
        var tasks = project.tasks
        tasks.remove(atOffsets: offsets)
    }

    private func move(from source: IndexSet, to destination: Int) {
        
    }
    
    private func onAppear() {
        Database().getTasks(project: self.project) { (snap, error) in
            let result = Result {
                try snap!.documents.compactMap {
                    try $0.data(as: Task.self)
                }
            }
            switch result {
                case .success(let t):
                    self.tasks = t
                case .failure(let error):
                    print("Error decoding projects: \(error)")
            }
        }
    }
    
}

enum ActiveSheet {
   case edit, add
}
