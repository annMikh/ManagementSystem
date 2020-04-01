//
//  CommonDateFormatter.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 02.02.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation


class Formatter {
        
    private static var formatter = DateFormatter()
    
    static func getDateWithFormate(formate : String = "dd.MM.yyyy") -> Date {
        return formatter.date(from: formate) ?? Date()
    }
    
    static func getStringWithFormate(date: Date?, formate : String = "dd.MM.yyyy") -> String {
        formatter.dateFormat = formate
        return formatter.string(from: date ?? Date())
    }
    
    static func checkLength255(_ input: String) -> Bool {
        return input.count <= 255
    }
    
    static func checkLength50(_ input: String) -> Bool {
        return input.count <= 50
    }
    
    static func checkInput(_ inputs : Any?...) -> Bool {
        var flag = true
        for input in inputs {
            switch input {
            case let input as String:
                flag = flag && !input.isEmpty
            default:
                flag = flag && input != nil
            }
        }
        return flag
    }
}
