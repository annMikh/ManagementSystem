//
//  ResetPasswordScreen.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 01.04.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation
import SwiftUI

struct ResetPasswordScreen : View {
    
    @State private var email: String = ""
    @State private var isIncorrectInput: Bool = false
    @State private var isErrorAuth: Bool = false
    @State private var isSuccessAuth: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    @State var session = Session.shared
    
    var body : some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                
                TextField("email address", text: $email)
                    .autocapitalization(.none)
                    .padding()
                    .border(Color.black, width: 2)
                    .padding(.all, 10)
                
                Button(action: {
                    if Formatter.checkInput(self.email) {
                        self.resetPassword()
                    } else {
                        self.isIncorrectInput.toggle()
                    }
                }) {
                    HStack {
                        Spacer()
                        Text("RESET PASSWORD")
                            .font(.headline)
                            .foregroundColor(Color.white)
                        Spacer()
                    }
                }
                .padding(.vertical, 10.0)
                .background(Color.primaryBlue)
                .cornerRadius(6.0)
                .padding(.horizontal, 50)
                .padding(.bottom, 50)
                .showAlert(title: Constant.ErrorTitle, text: Constant.ErrorInput, isPresent: $isIncorrectInput)
                
            }.navigationBarTitle(Text("Reset").bold(), displayMode: .inline)
             .navigationBarItems(leading: CancelButton)
             .showAlert(title: Constant.ResetPasswordErrorTitle, text: Constant.ResetPasswordErrorText, isPresent: $isErrorAuth)
            
        }.showAlert(title: Constant.ResetPasswordTitle,
                   text: Constant.ResetPasswordText,
                   isPresent: $isSuccessAuth,
                   action: { self.presentationMode.wrappedValue.dismiss() })
    }
    
    private var CancelButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("Cancel").foregroundColor(Color.primaryBlue)
        }
    }
    
    private func resetPassword() {
        session.resetPassword(email: self.email) { err in
            if err == nil {
                self.isSuccessAuth.toggle()
            } else {
                self.isErrorAuth.toggle()
            }
        }
    }
}
