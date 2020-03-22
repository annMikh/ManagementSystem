//
//  CreateProjectScreen.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 26.01.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation
import SwiftUI

struct CreateProjectScreen : View {
    
    @State private var selection = false
    static private var name = ""
    static private var tag = ""
    static private var description = ""
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var session: SessionViewModel
        
    var nameBinding = Binding<String>(get: { CreateProjectScreen.name }, set: { CreateProjectScreen.name = $0 } )
    var descriptionBinding = Binding<String>(get: { CreateProjectScreen.description }, set: { CreateProjectScreen.description = $0 } )
    var tagBinding = Binding<String>(get: { CreateProjectScreen.tag }, set: { CreateProjectScreen.tag = $0 } )
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                LabelTextField(label: "Project name", placeHolder: "Fill in project name", text: self.nameBinding)
                
                Text("Description").font(.headline).foregroundColor(Color.blue)
                MultilineTextField("Fill in project description", text: self.descriptionBinding, onCommit: { })
                    .padding(.all)
                    .border(Color.black, width: 2)
                    .cornerRadius(5.0)
                    .padding(.all, 10)
                    
                LabelTextField(label: "Tags", placeHolder: "Fill in tags for this project", text: self.tagBinding)
                
                Toggle(isOn: $selection) {
                    Text("Open access")
                }.padding()
                
                Spacer()
            }
                .navigationBarItems(leading: cancelButton, trailing: doneButton)
                .padding(.horizontal, 20)
        }
    }
    
    private var cancelButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("Cancel").foregroundColor(Color.blue)
        }
    }
    
    private var doneButton: some View {
        Button(action: {
            if (self.isValidInput()) {
                let project = Project(name: CreateProjectScreen.name, description: CreateProjectScreen.description)
                self.presentationMode.wrappedValue.dismiss()
                self.session.createProject(project: project)
            } else {
                 print("not valid input")
            }

        }) {
            Text("Done").foregroundColor(Color.blue)
        }
    }
    
    private func isValidInput() -> Bool {
        return !CreateProjectScreen.name.isEmpty && !CreateProjectScreen.description.isEmpty
    }
    
    private func clear() {
        CreateProjectScreen.name = ""
        CreateProjectScreen.description = ""
        CreateProjectScreen.tag = ""
        self.selection = false
    }
}


struct LabelTextField : View {
    
    var label: String
    var placeHolder: String
    
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label).font(.headline).foregroundColor(Color.blue)
            TextField(placeHolder, text: $text)
                .padding(.all)
                .border(Color.black, width: 2)
                .cornerRadius(5.0)
                .padding(.all, 10)
                
        }
    }
}

//struct CreateProjectView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateProjectScreen()
//    }
//}
