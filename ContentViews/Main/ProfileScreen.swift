//
//  ProfileScreen.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 18.03.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseAuth

struct ProfileView : View {
    
    @State private var isClickedLogOut = false
    @State private var isClickedEdit = false
    @State private var isIncorrectInput: Bool = false
    @State private var user : User?
    @State private var session = Session.shared
    @State private var pickerSelection = 0
    
    @State private var showImagePicker : Bool = false
    @State private var image = Session.shared.image
    @State private var manager = StorageManager()
    
    private var positions = Position.getAllCases()
        
    var body : some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack(alignment: .center, spacing: 30) {
                    Button(action: {
                        self.showImagePicker.toggle()
                    }) {
                        Image(uiImage: image!)
                            .renderingMode(.original)
                            .scaledToFit()
                            .frame(width: 100.0, height: 100.0)
                            .clipShape(Circle())
                            .padding(.top, 20)
                            .padding(.leading, 20)
                    }
                    
                    LabelTextField(label: "Email address",
                                   placeHolder: "",
                                   text: $session.currentUser.bound.email)
                        .disabled(true)
                        .disableAutocorrection(true)
                        .padding(.top, 20)
                }

                Group {
                    LabelTextField(label: "Your name",
                                   placeHolder: "enter your name",
                                   text: $session.currentUser.bound.name)
                    LabelTextField(label: "Your lastname",
                                   placeHolder: "enter your lastname",
                                   text: $session.currentUser.bound.lastName)
                }
                .foregroundColor(self.isClickedEdit ? Color.blue : Color.black)
                .disabled(!self.isClickedEdit)
                .padding()
                
                VStack(alignment: .leading) {
                    Text("Position")
                        .font(.headline)
                        .foregroundColor(Color.primaryBlue)
                        .padding()
                    
                    HStack {
                        Spacer()
                        Picker(selection: $pickerSelection, label: Text("")) {
                            ForEach(0 ..< self.positions.count) { index in
                                Text(self.positions[index])
                                    .foregroundColor(self.isClickedEdit ? Color.blue : Color.black)
                                    .tag(index)
                            }
                        }
                        .pickerStyle(DefaultPickerStyle())
                        .frame(maxHeight: 70)
                        .disabled(!self.isClickedEdit)
                        .labelsHidden()
                        
                        Spacer()
                    }
                }
            
                Spacer(minLength: 100)
                
                VStack(alignment: .leading) {
                    Divider()
                    EditProfileButton
                    Divider()
                    LogOutButton
                }.padding()
            }
        }.showAlert(title: Constant.ErrorTitle, text: Constant.ErrorInput, isPresent: $isIncorrectInput)
         .navigationViewStyle(StackNavigationViewStyle())
         .onAppear {
            self.pickerSelection =
                self.positions.firstIndex(of: self.session.currentUser?.position.rawValue ?? "") ?? 0
        }
        .sheet(isPresented: $showImagePicker, onDismiss: self.saveImage) {
            ImagePicker(isShown: self.$showImagePicker, image: self.$image)
        }
    }
    
    func saveImage() {
        if let data = image {
            image = manager.resizeImage(image: data, targetSize: CGSize(width: 100, height: 100))
            session.image = image
            StorageManager().uploadImageData(data: data, serverFileName: "\(session.currentUser.bound.uid).png")
        }
    }
    
    /// Button for log out
    private var LogOutButton : some View {
        HStack {
            Spacer()
            NavigationLink(destination: LoginView().navigationBarBackButtonHidden(true),
                           isActive: $isClickedLogOut) {
                Button(action: {
                    do {
                        try self.session.logOut()
                        UserPreferences.setLogIn(false)
                        self.session.clearSession()
                        self.isClickedLogOut.toggle()
                    } catch {
                        print("log out error")
                    }
                }){
                    HStack(alignment: .center) {
                        Image("logOut")
                            .resizable()
                            .frame(width: 15.0, height: 15.0)
                            .foregroundColor(.fadedRed)
                            .padding(.all, 4)
                            .overlay(
                                RoundedRectangle(cornerRadius: CGFloat(2.0))
                                    .stroke(Color.fadedRed, lineWidth: CGFloat(1.0))
                            )

                        Text("Log Out").foregroundColor(.fadedRed)
                    }
                }
            }
            Spacer()
        }
    }
    
    /// Button to edit user's name, last name and position
    private var EditProfileButton : some View {
        HStack(alignment: .center) {
            Spacer()
            Button(action: self.handleEditClick) {
                HStack(alignment: .center) {
                    Image(systemName: self.isClickedEdit ? "pencil.slash" : "pencil")
                        .resizable()
                        .foregroundColor(.blue)
                        .frame(width: 15.0, height: 15.0)
                        .padding(.all, 4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.blue, lineWidth: 1)
                        )
                    Text("Edit profile").foregroundColor(.blue)
                }
            }
            Spacer()
        }
    }
    
    private func handleEditClick() {
        isIncorrectInput = !Formatter.checkInput(session.currentUser?.name,
                                                 session.currentUser?.lastName)
        
        if !isIncorrectInput{
            isClickedEdit.toggle()
            if !isClickedEdit  {
                session.currentUser?.position = Position(position: positions[pickerSelection])
                session.updateProfile(user: self.session.currentUser)
            }
        }
    }
}
