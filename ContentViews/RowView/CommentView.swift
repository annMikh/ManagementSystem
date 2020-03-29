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
    
    var comment: Comment
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Image(systemName: "person")
                    .resizable()
                    .frame(width: 50.0, height: 50.0)
                    .padding(.horizontal, 5)
                
                VStack(alignment: .leading) {
                    Text(comment.author.getFullName())
                        .font(.body)
                        .bold()
                        .padding(.horizontal, 10).padding(.top, 5)
                    
                    Text(DFormatter.getStringWithFormate(date: comment.date))
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 10)
                }
                Spacer()
            }.padding(.top, 5)
            
            Divider()
            Text(comment.text).font(.body).padding(.horizontal, 20).padding(.bottom, 5)
            
        }
            .overlay(RoundedRectangle(cornerRadius: 4)
            .stroke(Color.blue, lineWidth: 1))
    }
}
