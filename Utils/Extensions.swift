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
    
    static func getColor(pos : Position) -> Color {
        switch pos {
            case .Designer:
                return .pink
            case .Developer:
                return .blue
            case .Manager:
                return .green
            case .Tester:
                return .purple
            default:
                return .red
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
