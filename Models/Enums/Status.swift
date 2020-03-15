//
//  Status.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 26.01.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation

enum Status : String, CaseIterable, Codable {
    
    case New = "New"
    case InDevelopment = "In development"
    case InProgress = "In progress"
    case ReadyForTesting = "Ready for testing"
    case Completed = "Completed"
    case Deprecated = "Deprecated"
    
    var description: String {
        return self.rawValue
    }
}
