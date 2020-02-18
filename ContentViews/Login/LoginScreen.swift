//
//  ContentView.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 25.01.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @State var email: String = ""
    @State var password: String = ""
    
    var body: some View {
    
        NavigationView {
            VStack(alignment: .leading) {
                    
                    Group {
                        TextField("email address", text: $email).padding()
                        SecureField("password", text: $password).padding()

                    }
                    .border(Color.black, width: 2)
                    .padding(.all, 10)
                    
                NextButton()
                
                Spacer()
                NavigationLink(destination: RegisterView()) {
                    Text("Haven't got an account?")
                        .foregroundColor(.blue)
                        .padding(.horizontal, 110)
                }
                
            }
                .navigationBarTitle(
                    Text("Log In")
                        .font(.largeTitle)
                        .foregroundColor(.primary)
                )
    }

    }
}

struct NextButton : View {
    
    var body: some View {
        NavigationLink(destination: MainScreen()) {
            Button(action: {
                print("login tapped")
            }) {
                HStack {
                    Spacer()
                    Text("NEXT")
                        .font(.headline)
                        .foregroundColor(Color.white)
                    Spacer()
                }
            }
            .padding(.vertical, 10.0)
            .background(Color.blue)
            .cornerRadius(6.0)
            .padding(.horizontal, 50)
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
