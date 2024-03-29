//
//  AccessType.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 26.01.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation


enum AccessType: String, CaseIterable, Codable {
    
    init(mode: String) {
        switch mode {
        case "open":
            self  = .open
        default:
            self = .close
        }
    }
    
    case open, close 
    
    var description: String {
        return self.rawValue
    }
    
    func isOpen() -> Bool {
        return self.rawValue == "open"
    }
}
