//
//  Boards.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 29.03.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation
import SwiftUI

struct Boards : View {
    
    @State private var showingDetail = false
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text("Boards")
                .font(.largeTitle)
                .foregroundColor(.primary)
        }
    }
    
}
