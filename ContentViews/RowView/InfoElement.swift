//
//  InfoElement.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 11.04.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation
import SwiftUI

struct InfoElement : View {
    
    var title: String
    var text: String
    
    var body : some View {
        VStack(alignment: .leading) {
            Divider()
            
            Text(title)
                .bold()
                .font(.headline)
                .foregroundColor(Color.primaryBlue)
                .padding(.horizontal, 10)
            
            Text(text)
                .padding(.horizontal, 25)
                .padding(.top, 5)
        }
    }
}
