//
//  EmptyListTextView.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 29.03.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation
import SwiftUI

struct EmptyListTextView : View {
    
    var title: String
    
    var body : some View {
        VStack(alignment: .center) {
            Spacer()
            HStack(alignment: .center) {
                Spacer()
                Text(title)
                    .foregroundColor(.gray)
                    .padding()
                Spacer()
            }
            Spacer()
        }
    }
}
