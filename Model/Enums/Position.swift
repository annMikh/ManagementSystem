//
//  Position.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 26.01.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation

enum Position : String, CaseIterable, Codable {
    
    init(position: String){
        switch position {
        case "Developer":
            self  = .Developer
        case "Tester":
            self  = .Tester
        case "Manager":
            self  = .Manager
        case "Designer":
            self  = .Designer
        case "Other":
            self  = .Other
        default:
            self = .None
        }
    }
    
    static func getAllCases() -> Array<String> {
        return Position.allCases
                        .filter { $0 != None }
                        .map { "\($0)" }
    }
    
    case Developer, Tester, Manager, Designer, Other, None
    
    var description: String {
        return self.rawValue
    }
}
