//
//  MainScreen.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 01.02.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation
import SwiftUI

struct MainView : View {

    @State var isPresentingAdd: Bool = false
    @State var isPresentingEdit: Bool = false
    @State var selectorIndex: Int = 0
    @State var searchValue : String = ""
    @State var isClickedProfile = false
    
    @EnvironmentObject var session: SessionViewModel
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = .blue
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.blue], for: .normal)
        
        UITableView.appearance().backgroundColor = .clear
        UITableView.appearance().separatorColor = .clear
    }
    
    private var projects = [Project(name: "first", description: "vjsvjjvsljvldjvs"), Project(name: "second", description: "description")]
        
    var body : some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(alignment: .leading) {
                HStack {
                    NavigationLink(destination: ProfileContent, isActive: $isClickedProfile) {
                        Button(action: {
                            self.isClickedProfile = true
                        }){
                        Image(systemName: "person")
                            .resizable()
                            .frame(width: 25.0, height: 25.0)
                            .padding(.horizontal, 10)
                        }
                    }.isDetailLink(false)
                    SearchBar(input: $searchValue)
                }
  
                Picker("projects", selection: $selectorIndex) {
                    Text("all").tag(0)
                    Text("personal").tag(1)
                }.pickerStyle(SegmentedPickerStyle())
                
                List {
                    if self.$selectorIndex.wrappedValue == 0 {
                        ForEach(projects, id: \.name) { proj in
                            ProjectView(project: proj)
                        }
                        .onDelete(perform: delete)
                        .onMove(perform: move)
                    } else {
                        ForEach(self.getOnlyMyProjects(), id: \.name) { proj in
                            ProjectView(project: proj)
                        }
                        .onDelete(perform: delete)
                        .onMove(perform: move)
                    }
                }
                
                Spacer()

            }
            
            FloatingButton(actionAdd: { self.isPresentingAdd.toggle() },
                           actionEdit: { self.isPresentingEdit.toggle() })
                .padding()
                .sheet(isPresented: self.$isPresentingAdd) {
                    CreateProjectScreen().environmentObject(self.session)
                }
            
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func getOnlyMyProjects() -> [Project] {
        return self.projects.filter { $0.creator == "" }
    }
    
    
    private func delete(at offsets: IndexSet) {
    
    }

    private func move(from source: IndexSet, to destination: Int) {
    }
    
    private var ProfileContent : some View {
        ProfileView()
            .navigationBarTitle(Text("Profile").bold())
            .navigationBarBackButtonHidden(false)
            .environmentObject(session)
    }
}

struct Boards : View {
    
    @State private var showingDetail = false
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text("Boards")
                .font(.largeTitle)
                .foregroundColor(.primary)
            
            Spacer()
        
            Image(systemName: "plus")
                .padding(.all, 10)
                .sheet(isPresented: $showingDetail) {
                    CreateProjectScreen()
                }
        }
    }
    
}
