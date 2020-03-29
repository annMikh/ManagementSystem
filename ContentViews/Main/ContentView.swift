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
    
    @EnvironmentObject var session : SessionViewModel

    var body: some View {
        AnyView({ () -> AnyView in
            if (!UserPreferences.getLogIn()) {
                return AnyView(LoginView().environmentObject(session))
            } else {
                return AnyView(mainView)
            }
            }())
            .onAppear { self.session.currentSession() }
            .onDisappear {  }
    }
    
    var mainView : some View {
        NavigationView {
            MainView()
                .environmentObject(session)
                .navigationBarTitle(
                 Text("Boards")
                     .font(.largeTitle)
                     .foregroundColor(.primary)
                )
                .navigationBarBackButtonHidden(true)
        }
    }
}
