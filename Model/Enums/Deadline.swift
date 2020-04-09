//
//  Deadline.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 29.03.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation

enum Deadline : String {
    
    case NoDeadline, Deadline
    
    var description: String {
        return self.rawValue
    }
}
