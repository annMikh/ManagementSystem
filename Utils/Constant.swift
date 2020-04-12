//
//  Constant.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 28.03.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation
import SwiftUI

public struct Constant {
    
    public static let ErrorTitle = "Error"
    public static let ErrorInput = "Please, fill in all fields correctly"
    public static let ErrorRegister = "Please, check password field - it should contain 6 characters at least"
    
    public static let EmptyProjectsTitle = "You don't have any projects yet"
    public static let EmptyTasksTitle = "There aren't any tasks with chosen priority yet"
    
    public static let ResetPasswordErrorTitle = "Reset error"
    public static let ResetPasswordErrorText = "Check your email address"
    
    public static let ResetPasswordTitle = "Reset password"
    public static let ResetPasswordText = "We have just sent you a password reset email.\nPlease, check your inbox and follow the instructions to reset your password."
    
    public static let CommentTitle = "New comment"
    
    public static let ErrorEditTitle = "You haven't got permissions\nto edit this task"
    
    public static let searchUser = "Please, enter the word \nto search the users by email"
    
    public static let PermissionDelete = "You can't delete this project \nbecause you aren't the creator"
    public static let PermissionUpdate = "You can't edit this project \nbecause you aren't the creator"
}
