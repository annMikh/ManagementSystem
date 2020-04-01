//
//  MainScreen.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 01.02.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation
import SwiftUI
import Firebase

struct MainView : View, Searchable {


    @State private var selectorType: Int = 0
    @State private var searchValue : String = ""
    @State private var activeSheet : ActiveSheet = .add
    
    @State private var isClickedProfile = false
    @State private var isProjectLoaded = false
    @State private var isSearchMode = false
    @State private var isPresentingAdd: Bool = false
    @State private var isPresentingEdit: Bool = false
    
    @State private var projects = [Project]()
    
    @EnvironmentObject var session: SessionViewModel
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = .blue
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.blue], for: .normal)
        
        UITableView.appearance().backgroundColor = .clear
        UITableView.appearance().separatorColor = .clear
    }
            
    var body : some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(alignment: .leading) {
                HStack {
                    NavigationLink(destination: ProfileContent, isActive: $isClickedProfile) {
                        Button(action: { self.isClickedProfile.toggle() }){
                        Image(systemName: "person")
                            .resizable()
                            .frame(width: 25.0, height: 25.0)
                            .padding(.horizontal, 10)
                        }
                    }
                    SearchBar()
                }
  
                Picker("projects", selection: $selectorType) {
                    Text("all").tag(0)
                    Text("personal").tag(1)
                }.pickerStyle(SegmentedPickerStyle())
                
                if self.shoudShowList() {
                    List {
                        ForEach(self.$selectorType.wrappedValue == 0 ? self.projects : self.getOnlyMyProjects(), id: \.id) { proj in
                            ProjectView(project: proj)
                        }
                        .onDelete(perform: delete)
                        .onMove(perform: move)
                    }
                    .environment(\.editMode, .constant(self.isPresentingEdit ? EditMode.active : EditMode.inactive))
                    .animation(Animation.spring())
                } else {
                    SearchList
                }
                
                Spacer()
            }
            
            if self.isEmptyListShown() {
                EmptyListTextView(title: Constant.EmptyProjectsTitle).animation(.easeInOut)
            }
            
            FloatButton
            
        }.navigationViewStyle(StackNavigationViewStyle())
         .onAppear(perform: self.onAppear)
    }
    
    private func getOnlyMyProjects() -> [Project] {
        return self.projects.filter { $0.creator == self.session.currentUser.bound.uid }
    }
    
    private func shoudShowList() -> Bool {
        //self.onAppear()
        return !self.isSearchMode
    }
    
    private func isEmptyListShown() -> Bool {
        return self.isProjectLoaded && self.projects.isEmpty && !self.isSearchMode
    }
    
    func updateSearchResult(input: String) {
        if self.isSearchMode {
            Database().loadProjectsByName(input: input,
                                          com: self.updateProjects(snap:err:))
        }
    }
    
    private func onAppear() {
        Database().getProjects(me: self.session.currentUser.bound,
                               com: self.updateProjects(snap:err:))
        self.session.currentSession()
    }
    
    private func updateProjects(snap: QuerySnapshot?, err: Error?) {
        let result = Result {
               try snap!.documents.compactMap {
                   try $0.data(as: Project.self)
               }
        }
       switch result {
           case .success(let proj):
               self.projects = proj
           case .failure(let error):
               print("Error decoding projects: \(error)")
       }
       self.isProjectLoaded = true
    }
    
    private func delete(at offsets: IndexSet) {
        // TODO delete by index
        for index in offsets {
            if Permission.toEditProject(project: self.projects[index]) {
                self.session.deleteProject(self.projects[index]) { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        self.projects.remove(atOffsets: offsets)
                    }
                }
            }
        }
    }

    private func move(from source: IndexSet, to destination: Int) {
        self.projects.move(fromOffsets: source, toOffset: destination)
    }
    
    private var FloatButton : some View {
        FloatingButton(actionAdd: {
                        self.activeSheet = .add
                        self.isPresentingAdd.toggle()
            
        },
                       actionEdit: {
                        self.activeSheet = .edit
                        self.isPresentingEdit.toggle()
        })
            .padding()
            .sheet(isPresented: self.$isPresentingAdd) {
                if self.activeSheet == .add {
                   CreateProjectScreen().environmentObject(self.session)
                }
            }
    }
    
    private var SearchList : some View {
        List {
            ForEach(self.projects, id: \.id) { proj in
                ProjectView(project: proj)
            }
        }
    }
    
    private var ProfileContent : some View {
        ProfileView()
            .navigationBarTitle(Text("Profile").bold())
            .navigationBarBackButtonHidden(false)
            .environmentObject(session)
    }
}
