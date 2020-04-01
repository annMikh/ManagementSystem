//
//  SearchBar.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 28.03.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation
import SwiftUI

struct SearchBar : View {
    
    @State private var searchText = ""
    @State private var showCancelButton: Bool = false

    var body: some View {
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")

                    TextField("search", text: $searchText, onEditingChanged: { isEditing in
                        self.showCancelButton = true
                    }, onCommit: { }).foregroundColor(.primary)

                    Button(action: { self.searchText = "" }) {
                        Image(systemName: "xmark.circle.fill").opacity(searchText.isEmpty ? 0 : 1)
                    }
                }
                .padding(.all, 7)
                .foregroundColor(.secondary)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5.0)

                if showCancelButton  {
                    Button(action : {
                            UIApplication.shared.endEditing(true)
                            self.searchText = ""
                            self.showCancelButton = false
                    }) {
                        Image("Cancel")
                            .resizable()
                            .frame(width: 55.0, height: 18.0)
                    }
                }
            }.padding(.horizontal)
    }
}
    

extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged{_ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

extension View {
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
}
