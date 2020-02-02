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
    @State private var searchValue : String = ""
    
    private var projects = [Project(name: "first", description: ""), Project(name: "second", description: "description")]
    
    var body : some View {
        NavigationView{
            VStack(alignment: .leading) {
                SearchBar(input: $searchValue)
  
                Picker("projects", selection: $selectorIndex) {
                    Text("new")
                    Text("personal")
                }
                .pickerStyle(SegmentedPickerStyle())
                
                ForEach(projects, id: \.name) { proj in
                    ProjectRowView(project: proj)
                }
                
                //in List {}
//                ForEach(self.names.filter{
//                    self.searchTerm.isEmpty ? true : $0.localizedStandardContains(self.searchTerm)
//                }, id: \.self) { name in
//                    Text(name)
//                }
                
                Spacer()
            }.navigationBarTitle(
                Text("Boards")
                    .font(.largeTitle)
                    .foregroundColor(.primary))
            .navigationBarItems(leading: EditButton(), trailing: addProject)

        }
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
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text("Boards")
                .font(.largeTitle)
                .foregroundColor(.primary)
            Spacer()
            Image(systemName: "plus")
                .padding(.all, 10)
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
    
    func makeCoordinator() -> SearchBar.Cordinator {
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


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}

struct ProjectRowView : View {
    @ObservedObject var project: Project
    
    var body: some View {
        NavigationLink(destination: ProjectView(project: project)) {
            HStack(alignment: .firstTextBaseline) {
                Image(systemName: "heart.circle.fill")
                    .resizable()
                    .frame(width: 50.0, height: 50.0)
                    .padding(.horizontal, 10)
                
                Text(project.name)
                    .lineLimit(nil)
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

