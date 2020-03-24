//
//  UserPreferences.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 23.03.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation


public class UserPreferences {
    
    private static let isLoginKey = "isLogin"
    
    public static func setLogIn(_ isLogin: Bool) {
        UserDefaults.standard.set(isLogin, forKey: isLoginKey)
    }
    
    public static func getLogIn() -> Bool {
        return UserDefaults.standard.bool(forKey: isLoginKey)
    }
    
}
