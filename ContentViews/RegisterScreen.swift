//
//  RegisterScreen.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 25.01.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import SwiftUI

struct RegisterView: View {
    @State var email: String = ""
    @State var name: String = ""
    @State var position: String = ""
    @State var password: String = ""
    
    var body: some View {
    
            VStack(alignment: .leading) {
                    Text("Register")
                        .font(.largeTitle)
                        .foregroundColor(.primary)
                        .fixedSize()
                        .frame(width: 100, height: 50)
                        .padding(.horizontal, 20)
                    
                    Group {
                        TextField("email address", text: $email).padding()
                        TextField("name", text: $email).padding()
                        TextField("position", text: $email).padding()
                        
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

struct RegiesterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
