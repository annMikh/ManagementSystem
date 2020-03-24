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

    @State var isPresentingModal: Bool = false
    @State var selectorIndex: Int = 0
    @State var searchValue : String = ""
    @State var isClickedProfile = false
    
    @EnvironmentObject var session: SessionViewModel
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = .blue
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.blue], for: .normal)
    }
    
    private var projects = [Project(name: "first", description: "vjsvjjvsljvldjvs"), Project(name: "second", description: "description")]
        
    var body : some View {
            VStack(alignment: .leading) {
                HStack {
                    NavigationLink(destination: profileContent, isActive: $isClickedProfile) {
                        Button(action: {
                            self.isClickedProfile = true
                        }){
                        Image(systemName: "person")
                            .resizable()
                            .frame(width: 25.0, height: 25.0)
                            .padding(.horizontal, 10)
                        }
                    }
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
            .navigationViewStyle(StackNavigationViewStyle())
        }.onAppear{
            //Database().getProjects()
        }
    }
    
    private func getOnlyMyProjects() -> [Project] {
        return self.projects.filter { $0.creator == SessionViewModel.me }
    }
    
    
    private func delete(at offsets: IndexSet) {
    
    }

    private func move(from source: IndexSet, to destination: Int) {
    }
    
    private var profileContent : some View {
        ProfileView()
            .navigationBarTitle(Text("Profile").bold())
            .navigationBarBackButtonHidden(false)
            .environmentObject(session)
    }
    
    private var addProject: some View {
        Button(action: {
            self.isPresentingModal = true
        }) {
            Image(systemName: "plus")
            .font(.title)
        }.sheet(isPresented: self.$isPresentingModal) {
            CreateProjectScreen().environmentObject(self.session)
        }
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

struct SearchBar : UIViewRepresentable {
    @Binding var input : String
    
    class Cordinator : NSObject, UISearchBarDelegate {
        
        @Binding var text : String
        
        init(text : Binding<String>) {
            _text = text
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
    }
    
    func makeCoordinator() -> Cordinator {
        return Cordinator(text: $input)
    }
    
    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = input
    }
    
}

struct ProjectView : View {
    
    @ObservedObject var project: Project
    
    var body: some View {
        NavigationLink(destination: projectContent) {
            HStack(alignment: .top) {
                Divider().background(AccessType.getColor(type: project.accessType))
            
                Image(systemName: "folder")
                    .resizable()
                    .frame(width: 40.0, height: 40.0)
                    .padding(.horizontal, 10)
            
                
                VStack(alignment: .leading) {
                    Text(project.name)
                        .lineLimit(1)
                        .font(.title)
                    
                    HStack(alignment: .firstTextBaseline) {
                        Text(project.description)
                            .lineLimit(1)
                            .font(.footnote)
                        Spacer()
                        Text(CommonDateFormatter.getStringWithFormate(date: project.date))
                            .lineLimit(nil)
                            .font(.footnote)
                    }
                }
            }
            .frame(height: 50)
            .padding([.trailing, .top, .bottom])
        }
    }

    
    var projectContent : some View {
        ProjectContentScreen(project: project)
                                .navigationBarTitle(project.name)
                                .navigationBarBackButtonHidden(false)
    }
    
}
