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
    
    @State var showMenuAdd = false
    @State var showMenuEdit = false
    
    var actionAdd: ()->()
    var actionEdit: ()->()
    
    
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
                self.showMenu()
            }) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.blue)
                    .shadow(color: .gray, radius: 0.2, x: 1, y: 1)
            }
        }
    }
    
    func showMenu() {
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