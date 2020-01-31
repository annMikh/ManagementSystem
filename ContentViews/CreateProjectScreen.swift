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
    
    @State private var selection = true
    
    private let types = ["open", "close"]
    
    var body: some View {
        VStack(alignment: .leading) {
            LabelTextField(label: "Project name", placeHolder: "Fill in project name")
            LabelTextField(label: "Description", placeHolder: "Fill in project description")
            
            Text("Tags")
        
            
            Toggle(isOn: $selection) {
                Text("Open access")
            }.padding()
            
        }
    }
    
}


struct LabelTextField : View {
    
    var label: String
    var placeHolder: String
    
    @State var value: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label).font(.headline).foregroundColor(Color.black)
            TextField(placeHolder, text: $value)
                .padding(.all)
                .border(Color.gray, width: 2)
                .cornerRadius(5.0)
                .padding(.all, 10)
                
        }
    }
}

struct CreateProjectView_Previews: PreviewProvider {
    static var previews: some View {
        CreateProjectScreen()
    }
}
