//
//  FloatingButton.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 28.03.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation
import SwiftUI

struct FloatingButton : View {
    
    @State var showMenuAdd: Bool = false
    @State var showMenuEdit: Bool = false
    
    var actionAdd: ()->()
    var actionEdit: ()->()
    
    init(actionAdd: @escaping ()->(), actionEdit: @escaping ()->()) {
        self.actionAdd = actionAdd
        self.actionEdit = actionEdit
    }
    
    var body : some View {
        VStack {
            Spacer()
            
            if showMenuAdd {
                Button(action: self.actionAdd) {
                    MenuItem(icon: "plus.circle")
                }
            }
            
            if showMenuEdit {
                Button(action: self.actionEdit) {
                    MenuItem(icon: "pencil")
                }
            }
            
            Button(action: {
                self.changeMenuVisibility()
            }) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.blue)
                    .shadow(color: .gray, radius: 0.2, x: 1, y: 1)
            }
        }
    }
    
    func changeMenuVisibility() {
        withAnimation {
            self.showMenuEdit.toggle()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            withAnimation {
                self.showMenuAdd.toggle()
            }
        })
    }
}

struct MenuItem: View {
    
    var icon: String
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.blue)
                .frame(width: 45, height: 45)
            
            Image(systemName: self.icon)
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundColor(.white)
                .padding()
        }
        .transition(.move(edge: .trailing))
    }
}
