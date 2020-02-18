//
//  TaskContentScreen.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 17.02.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation
import SwiftUI

struct TaskContentScreen : View {
    
    @ObservedObject var task: Task
    
    var body : some View {
        VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Image(systemName: "heart.circle.fill")
                        .resizable()
                        .frame(width: 50.0, height: 50.0)
                        .padding(.horizontal, 10)
                    
                    Spacer()
                    HStack {
                        Spacer()
                        Text(task.assignedUser!.name + " " + task.assignedUser!.lastName).padding()
                        Spacer()
                    }
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.white, lineWidth: 1))
                    Spacer()
                }
                
                Spacer()
                
                Text("Description").font(.title).padding()
                HStack(alignment: .top) {
                        Text(task.description)
                            .frame(minHeight: 100, maxHeight: 100)
                                .padding()
                        Spacer()
                    }
                        .overlay(RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.white, lineWidth: 1))
                    
                Spacer()
                
                Text("Assigned by").font(.title).padding()
                HStack {
                    Spacer()
                    Text(task.author!.name + " " + task.author!.lastName)
                        .frame(minWidth: 200, maxWidth: 200)
                        .padding()
                    Spacer()
                }
                    .overlay(RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.white, lineWidth: 1))
                
                Spacer()
                
                HStack(alignment: .firstTextBaseline){
                    Text("Comments").font(.title).padding()
                    
                    Image(systemName: "heart.circle.fill")
                        .resizable()
                        .frame(width: 20.0, height: 20.0)
                        .padding(.horizontal, 5)
                    Spacer()
                }
                
            }.padding()
        .navigationBarTitle(Text(task.name).font(.title))
    }
}
