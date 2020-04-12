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
    @State var image : UIImage? = UIImage()
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Divider()
            
            HStack(alignment: .center) {
                Image(uiImage: image!)
                    .resizable()
                    .frame(width: 50.0, height: 50.0)
                    .clipShape(Circle())
                    .padding(.all, 3)
                    .padding(.leading, 10)
                    .animation(.easeInOut)
                
                VStack(alignment: .leading) {
                    Text(name).bold()
                
                    Text(Formatter.getStringWithFormate(date: comment.date))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            
            Text(comment.text)
                .font(.body)
                .padding(.leading, 25)
            
        }.onAppear { self.loadUserName() }
    }
    
    private func loadUserName() {
        UserStore().loadUser(uid: comment.author) { (doc, err) in
            if err == nil {
                let user = User(dictionary: doc?.data() ?? [String : Any]())!
                self.name = user.getFullName()
            }
        }
        StorageManager().downloadImage(uid: comment.author) { data, err in
            if err == nil && data != nil {
                self.image = UIImage(data: data!)
            }
        }
    }
}
