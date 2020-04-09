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
            Divider()
            HStack(alignment: .center) {
                Image(systemName: "person")
                    .resizable()
                    .frame(width: 20.0, height: 20.0)
                    .padding(.all, 3)
                    .padding(.leading, 10)
                
                VStack(alignment: .leading) {
                    Text(name).bold()
                
                    Text(Formatter.getStringWithFormate(date: comment.date))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            
            Text(comment.text).font(.body).padding(.leading, 25)
        }
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
