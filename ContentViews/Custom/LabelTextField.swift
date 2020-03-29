//
//  LabelTextField.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 28.03.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation
import SwiftUI

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
