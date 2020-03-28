//
//  ProjectView.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 28.03.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation
import SwiftUI

struct ProjectView : View {
    
    @ObservedObject var project: Project
    
    var body: some View {
        NavigationLink(destination: ProjectContent) {
            VStack {
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
                            Text(DFormatter.getStringWithFormate(date: project.date))
                                .lineLimit(nil)
                                .font(.footnote)
                        }
                    }
                }
                .frame(height: 50)
                .padding([.trailing, .top, .bottom])
                
                Divider()
            }
        }
    }

    
    var ProjectContent : some View {
        ProjectContentScreen(project: project)
                                .navigationBarTitle(project.name)
                                .navigationBarBackButtonHidden(false)
    }
    
}
