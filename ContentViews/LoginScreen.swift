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
    
            VStack(alignment: .leading) {
                    Text("Log In")
                        .font(.largeTitle)
                        .foregroundColor(.primary)
                        .fixedSize()
                        .frame(width: 100, height: 50)
                    
                    Group {
                        TextField("email address", text: $email).padding()
                        
                        SecureField("password", text: $password).padding()
                
                    }
                    .border(Color.black, width: 2)
                    .frame(width: 400, height: 50)
                    .padding(.all, 10)
            
                Spacer()
            
                NextButton()
            }

    }
}

struct NextButton : View {
    
    var body: some View {
        Button(action: {}) {
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


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
