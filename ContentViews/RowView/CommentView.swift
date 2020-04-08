//
//  CommentView.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 28.03.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation
import SwiftUI

struct CommentView : View {
    
    @State var comment: Comment
    @State var name : String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Image(systemName: "person")
                    .resizable()
                    .frame(width: 25.0, height: 25.0)
                    .padding(.all, 5)
                
                VStack(alignment: .leading) {
                    Text(name)
                        .font(.body)
                        .bold()
                        .padding(.horizontal, 10).padding(.top, 5)
                    
                    Text(Formatter.getStringWithFormate(date: comment.date))
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 10)
                }.padding(.all, 5)
                Spacer()
            }
            
            Divider()
            Text(comment.text).font(.body).padding(.horizontal, 20).padding(.bottom, 5)
            
        }
            .overlay(RoundedRectangle(cornerRadius: 4)
            .stroke(Color.blue, lineWidth: 1))
            .padding()
            .onAppear { self.loadUserName() }
    }
    
    func loadUserName() {
        Database.shared.getUser(userId: comment.author) { (doc, err) in
            if err == nil {
                let user = User(dictionary: doc!.data() ?? [String : Any]())!
                self.name = user.getFullName()
            }
        }
    }
}
