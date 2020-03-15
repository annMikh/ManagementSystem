//
//  Position.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 26.01.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation

enum Position : String, CaseIterable, Codable {
    case Developer, Tester, Manager, Designer, Other, None
    
    var description: String {
        return self.rawValue
    }
}
