//
//  AccessType.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 26.01.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation


enum AccessType: String, CaseIterable, Codable {
    
    case open, close 
    
    var description: String {
        return self.rawValue
    }
}
