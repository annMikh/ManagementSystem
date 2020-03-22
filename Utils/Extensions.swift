//
//  Extensions.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 18.03.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation


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

extension Position {
    
    static func getImage(pos : Position) -> String {
        switch pos {
            case .Designer:
                return "person"
            case .Developer:
                return "person.fill"
            case .Manager:
                return "person.2"
            case .Tester:
                return "person.3"
            default:
                return "person.circle"
        }
    }
}
