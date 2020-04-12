//
//  Extensions.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 18.03.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation
import SwiftUI

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
            return _bound ?? User(name: "", lastName: "", email: "", position: Position.None, uid: "")
        }
        set {
            _bound = newValue
        }
    }
}

extension Optional where Wrapped == Int {
    
    var _bound: Int? {
        get {
            return self
        }
        set {
            self = newValue
        }
    }
    
    internal var bound: Int {
        get {
            return _bound ?? -1
        }
        set {
            _bound = newValue
        }
    }
}

extension Priority {
    static func getColor(priority: Priority) -> Color {
        switch priority {
        case .low:
            return .yellow
        case .critical:
            return .red
        case .medium:
            return .purple
        case .high:
            return .blue
        }
    }
}

extension AccessType {
    static func getColor(type: AccessType) -> Color {
        switch type {
        case .open:
            return .purple
        case .close:
            return .green
        }
    }
    
    static func getImage(acc : AccessType) -> String {
        switch acc {
            case .open:
                return "lock.open"
            default:
                return "lock"
        }
    }
}


extension View {
    public func showAlert(title: String, text: String, isPresent: Binding<Bool>, action: @escaping () -> Void = {}) -> some View  {
        return alert(isPresented: isPresent) {
            Alert(title: Text(title),
                  message: Text(text),
                  dismissButton: .default(Text("OK"), action: action))
        }
    }
}

extension String {
    
    var words: [SubSequence] {
        return split{ !$0.isLetter }
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

extension Color {
    
    public static let primaryBlueUI = UIColor(red: 0.471, green: 0.556, blue: 1, alpha: 1)
    public static let primaryGrayUI = UIColor(red: 0.933, green: 0.933, blue: 0.933, alpha: 1)
    
    public static let primaryBlue = Color(UIColor(red: 0.471, green: 0.556, blue: 1, alpha: 1))
    public static let primaryGray = Color(UIColor(red: 0.933, green: 0.933, blue: 0.933, alpha: 1))
    
    public static let fadedRed = Color(UIColor(red: 0.871, green: 0, blue: 0, alpha: 0.67))
    
}
