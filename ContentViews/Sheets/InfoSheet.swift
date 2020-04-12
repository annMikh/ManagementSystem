//
//  InfoSheet.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 11.04.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation
import SwiftUI

struct InfoSheet : View {
    
    var project : Project
    var author : User?
    
    var body : some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Spacer()
                Text("About project")
                    .bold()
                    .font(.title)
                Spacer()
            }

            InfoElement(title: "Name", text: project.name)
            InfoElement(title: "Description", text: project.description)
            InfoElement(title: "Date", text: Formatter.getStringWithFormate(date: project.date))
            InfoElement(title: "Creator", text: "\(author.bound.email) \n\(author.bound.getFullName())")
            
            if !project.tag.isEmpty {
                InfoElement(title: "Tag", text: project.tag)
            }
        }
    }
}
