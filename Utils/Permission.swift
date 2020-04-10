//
//  Permission.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 01.04.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation

class Permission {
    
    private static let session = Session.shared
    
    static func toEditProject(project: Project) -> Bool {
        return Permission.session.currentUser.bound.uid == project.creator
    }
    
    static func toEditTask(task: Task) -> Bool {
        return Permission.session.currentUser.bound.uid == task.author ||
                    Permission.session.currentUser.bound.uid == task.assignedUser
    }
    
    static func isPerticipant(project: Project) -> Bool {
        return project.participants.contains(Permission.session.currentUser.bound.uid)
    }
}
