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
    
    case New, Development, Progress, Testing, Completed, Deprecated
    
    var description: String {
        return self.rawValue
    }
}
