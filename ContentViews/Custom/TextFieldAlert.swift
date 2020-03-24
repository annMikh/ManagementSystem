//
//  TextFieldAlert.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 23.03.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation
import SwiftUI

struct TextFieldAlert : View {

    @Binding var isShowing: Bool
    @State var comment : String

    var body: some View {
            ZStack {
                VStack {
                    Text("Comment:")
                    Divider()
                    
                    TextField("enter comment", text: $comment).padding()
                    
                    Divider()
                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation {
                                self.isShowing.toggle()
                            }
                        }) {
                            Text("Cancel")
                        }
                        Spacer()
                        Divider()
                        Spacer()
                        Button(action: {
                            withAnimation {
                                self.isShowing.toggle()
                            }
                        }) {
                            Text("Post")
                        }
                        Spacer()
                    }
                }
                .padding()
                .frame(width: 300, height: 180)
                .background(Color.white)
                .shadow(radius: 1.0)
                .opacity(self.isShowing ? 1.0 : 0.0)
            }
        
    }

}
