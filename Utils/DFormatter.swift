//
//  CommonDateFormatter.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 02.02.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation


class DFormatter {
        
    private static var formatter = DateFormatter()
    
    static func getDateWithFormate(formate : String = "dd.MM.yyyy") -> Date {
        return formatter.date(from: formate) ?? Date()
    }
    
    static func getStringWithFormate(date: Date?, formate : String = "dd.MM.yyyy") -> String {
        formatter.dateFormat = formate
        return formatter.string(from: date ?? Date())
    }
}
