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

struct MainView : View {

    @State private var selectorType: Int = 0
    @State private var searchValue : String = ""
    @State private var activeSheet : ActiveSheet = .add
    
    @State private var isClickedProfile = false
    @State private var isClickedSearch = false
    @State private var isPresentingAdd: Bool = false
    @State private var isPresentingEdit: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    @State var session = SessionViewModel.shared
    @ObservedObject var store = ProjectStore.shared
    
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
                    
                    Spacer()
                    NavigationLink(destination: SearchView, isActive: $isClickedSearch) {
                        Button(action: { self.isClickedSearch.toggle() }) {
                            Image(systemName: "magnifyingglass")
                                .resizable()
                                .frame(width: 25.0, height: 25.0)
                                .padding(.horizontal, 10)
                        }
                    }
                }
  
                Picker("projects", selection: $selectorType) {
                    Text("all").tag(0)
                    Text("personal").tag(1)
                }.pickerStyle(SegmentedPickerStyle())
                
                List {
                    ForEach(self.$selectorType.wrappedValue == 0 ?
                        self.store.projects : self.store.projects.filter { $0.creator == self.session.currentUser.bound.uid },
                            id: \.id) { proj in
                        ProjectView(project: proj)
                    }
                    .onDelete(perform: delete)
                    .onMove(perform: move)
                }
                .environment(\.editMode, .constant(self.isPresentingEdit ? EditMode.active : EditMode.inactive))
                
                Spacer()
            }
            
            if self.isEmptyListShown() {
                EmptyListTextView(title: Constant.EmptyProjectsTitle)
                    .opacity(self.store.isLoad ? 1.0 : 0.0)
                    .animation(.easeInOut)
            }
            
            FloatButton
            
        }.navigationViewStyle(StackNavigationViewStyle())
         .onAppear(perform: self.onAppear)
    }
    
    private func isEmptyListShown() -> Bool {
        return self.store.projects.isEmpty
    }
    
    private func onAppear() {
        if self.session.currentUser == nil {
            self.session.currentSession()
        }
        self.store.loadProjects(user: self.session.session)
    }
    
    private func delete(at offsets: IndexSet) {
        offsets.forEach { index in
            self.store.deleteProject(index)
        }
    }

    private func move(from source: IndexSet, to destination: Int) {
        self.store.move(source: source, destination: destination)
    }
    
    private var FloatButton : some View {
        FloatingButton(actionAdd: {
                        self.activeSheet = .add
                        self.isPresentingAdd.toggle()
                        self.store.setState(state: .Add)
        },
                       actionEdit: {
                        self.activeSheet = .edit
                        self.isPresentingEdit.toggle()
                        self.store.setState(state: .Edit)
        })
            .padding()
            .sheet(isPresented: self.$isPresentingAdd) {
                if self.activeSheet == .add {
                    CreateProjectScreen()
                }
            }
    }
    
    private var ProfileContent : some View {
        ProfileView()
            .navigationBarTitle(Text("Profile").bold())
            .navigationBarBackButtonHidden(false)
    }
    
    private var SearchView : some View {
        SearchScreen()
            .navigationBarTitle(Text("Search").bold())
            .navigationBarBackButtonHidden(false)
    }
}
