//
//  CommonDateFormatter.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 02.02.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation


class CommonDateFormatter {
        
    private static var formatter = DateFormatter()
    
    static func getDateWithFormate(formate : String = "dd.MM.yyyy") -> Date {
        return formatter.date(from: formate) ?? Date()
    }
    
    static func getStringWithFormate(date: Date, formate : String = "dd.MM.yyyy") -> String {
        formatter.dateFormat = formate
        return formatter.string(from: date)
    }
}

extension Optional where Wrapped == String {
    
    var _bound: String? {
        get {
            return self
        }
        set {
            self = newValue
        }
    }
    
    public var bound: String {
        get {
            return _bound ?? ""
        }
        set {
            _bound = newValue.isEmpty ? nil : newValue
        }
    }
}

extension Optional where Wrapped == User {
    
    var _bound: User? {
        get {
            return self
        }
        set {
            self = newValue
        }
    }
    
    internal var bound: User {
        get {
            return _bound ?? User(name: "", lastName: "", position: Position.None, email: "")
        }
        set {
            _bound = newValue
        }
    }
}
