//
//  ParticipantView.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 02.04.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation
import SwiftUI

struct ParticipantView : View {
    
    var user: User
    @State var input: String
    @Binding var selectedItems: Set<User>
    @State var isSelected : Bool = false

    var body: some View {
        HStack {
            Text(self.user.email)
            Spacer()
            Image(systemName: "checkmark").opacity(self.isSelected ? 1.0 : 0.0)
        }.onTapGesture {
            self.isSelected.toggle()
        }
    }
}
