//
//  ContentView.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 03.03.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation
import SwiftUI

struct ContentView : View {
    
    @State var session = Session.shared

    var body: some View {
        AnyView({ () -> AnyView in
            if (UserPreferences.isLogIn()) {
                return AnyView(Main)
            } else {
                return AnyView(Login)
            }
            }())
    }
    
    var Main : some View {
        NavigationView {
            MainView()
                .navigationBarTitle(
                 Text("Boards")
                     .font(.largeTitle)
                     .foregroundColor(.primary)
                )
                .navigationBarBackButtonHidden(true)
        }
    }
    
    var Login : some View {
        NavigationView {
            LoginView()
        }
    }
}
