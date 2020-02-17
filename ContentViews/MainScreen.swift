//
//  MainScreen.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 01.02.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation
import SwiftUI

struct MainScreen : View {

    @State var isPresentingModal: Bool = false
    @State var selectorIndex: Int = 0
    @State var searchValue : String = ""
    
    private var projects = [Project(name: "first", description: ""), Project(name: "second", description: "description")]
    
    var body : some View {
        NavigationView {
            VStack(alignment: .leading) {
                SearchBar(input: $searchValue)
  
                Picker("projects", selection: $selectorIndex) {
                    Text("new")
                    Text("personal")
                }
                    .pickerStyle(SegmentedPickerStyle())
                
                List {
                    ForEach(projects, id: \.name) { proj in
                        ProjectView(project: proj)
                    }
                    .onDelete(perform: delete)
                    .onMove(perform: move)
                }
                
                Spacer()
            }.navigationBarTitle(
                Text("Boards")
                    .font(.largeTitle)
                    .foregroundColor(.primary))
            .navigationBarItems(leading: EditButton(), trailing: addProject)
        }
    }
    
    private func delete(at offsets: IndexSet) {
    
    }

    private func move(from source: IndexSet, to destination: Int) {
    }
    
    private var addProject: some View {
        Button(action: {
            self.isPresentingModal = true
        }) {
            Image(systemName: "plus.circle.fill")
            .font(.title)
        }.sheet(isPresented: $isPresentingModal) {
            CreateProjectScreen()
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
        NavigationLink(destination: ProjectContentScreen(project: project)) {
            HStack(alignment: .firstTextBaseline) {
                Image(systemName: "heart.circle.fill")
                    .resizable()
                    .frame(width: 50.0, height: 50.0)
                    .padding(.horizontal, 10)
                
                Text(project.name)
                    .lineLimit(1)
                    .font(.title)
                
                Spacer()
                Text(CommonDateFormatter().getStringWithFormate(date: project.date))
                    .lineLimit(nil)
                    .font(.title)
            }
            .padding([.trailing, .top, .bottom])
        }
    }
    
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}

