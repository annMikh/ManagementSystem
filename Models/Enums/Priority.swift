//
//  Priority.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 26.01.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation


enum Priority : String, CaseIterable, Codable {
    case low, medium, high, critical
    
    var description: String {
        return self.rawValue
    }
}
