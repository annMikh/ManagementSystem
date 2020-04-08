//
//  PositionView.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 01.04.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation
import SwiftUI

struct PositionView : View {
    
    let type : AccessType
    let project : String
    
    var body : some View {
        HStack {
            Image(systemName: AccessType.getImage(acc: type))
                .resizable()
                .frame(width: 15.0, height: 20.0)
                .padding(.horizontal, 10)
            
            Text(project)
                .bold()
                .font(.body)
                .padding(.trailing, 10)
            Spacer()
            
        }
    }
}
