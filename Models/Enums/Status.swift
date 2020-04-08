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
        case "InDevelopment":
            self  = .InDevelopment
        case "InProgress":
            self  = .InProgress
        case "ReadyForTesting":
            self  = .InDevelopment
        case "Completed":
            self  = .InProgress
        default:
            self  = .New
        }
    }
    
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
