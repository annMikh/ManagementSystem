//
//  SearchScreen.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 02.04.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation
import SwiftUI

struct SearchScreen : View {
    
    @State private var searchInput : String = ""
    @ObservedObject var store = ProjectStore()
    
    var body : some View {
        VStack {
            SearchBar(input: $searchInput)
            
            if self.searchInput.isEmpty {
                VStack(alignment: .center) {
                    Spacer()
                    Text("Please, enter the word \nto search the project by tag or name")
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    Spacer()
                }
            }
            else {
                List {
                    ForEach(self.filterList(), id: \.self) { proj in
                        ProjectView(project: proj)
                    }
                }.animation(.linear)
            }
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear { self.store.loadProjects() }
    }
    
    private func filterList() -> [Project] {
        return self.store.allProjects.filter(self.conditionFilter(project:))
    }
    
    private func conditionFilter(project: Project) -> Bool {
        let search = searchInput.lowercased()
        
        return (project.name.lowercased().contains(search)
                || project.tag.lowercased().contains(search))
                && project.accessType.isOpen()
    }
}
