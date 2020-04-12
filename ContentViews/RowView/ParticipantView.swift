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
    
    @EnvironmentObject var selections: Participants
    @State var isSelected : Bool = false
    @State var user : User

    var body: some View {
        VStack {
            HStack {
                Text(self.user.email)
                    .padding(.horizontal, 5)
                Spacer()
                Text(self.user.position.rawValue)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 5)
                Image(systemName: "checkmark").opacity(self.isSelected ? 1.0 : 0.0)
            }
            Divider()
        }
        .onAppear(perform: self.onAppear)
        .onTapGesture(perform: self.handleSelection)
    }
    
    private func onAppear() {
        self.isSelected = self.selections.users.contains(self.user)
    }
    
    private func handleSelection() {
        self.isSelected.toggle()
        if self.selections.users.contains(self.user) {
            if let i = self.selections.users.firstIndex(of: self.user) {
                self.selections.users.remove(at: i)
            }
        } else {
            self.selections.users.append(self.user)
        }
    }
    
}
