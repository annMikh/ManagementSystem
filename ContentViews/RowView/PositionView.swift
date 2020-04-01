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
    
    let position : Position
    let project : String
    
    var body : some View {
        HStack {
            Image(systemName: Position.getImage(pos: position))
                .resizable()
                .frame(width: 20.0, height: 20.0)
                .padding(.horizontal, 10)
            
            Text(String(describing: position))
                .bold()
                .font(.body)
            
            Spacer()
            
            Text(project)
                .foregroundColor(.gray)
                .font(.body)
                .padding(.trailing, 10)
        }
    }
}
