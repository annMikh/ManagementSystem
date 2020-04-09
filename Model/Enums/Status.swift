//
//  Status.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 26.01.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation

enum Status : String, CaseIterable, Codable {
    
    init(status: String){
        switch status {
        case "Deprecated":
            self  = .Deprecated
        case "Development":
            self  = .Development
        case "Progress":
            self  = .Progress
        case "Testing":
            self  = .Testing
        case "Completed":
            self  = .Completed
        default:
            self  = .New
        }
    }
    
    static func getAllCases() -> Array<String> {
        return Status.allCases.map{ "\($0)" }
    }
    
    case New = "New"
    case Development = "Development"
    case Progress = "Progress"
    case Testing = "Testing"
    case Completed = "Completed"
    case Deprecated = "Deprecated"
    
    var description: String {
        return self.rawValue
    }
}
