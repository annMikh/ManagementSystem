//
//  CommonDateFormatter.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 02.02.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation


class CommonDateFormatter {
        
    private var formatter = DateFormatter()
    
    func getDateWithFormate(formate : String = "MMMM-dd-yyyy HH:mm") -> Date {
        return formatter.date(from: formate) ?? Date()
    }
    
    func getStringWithFormate(date: Date, formate : String = "MMMM-dd-yyyy HH:mm") -> String {
        return formatter.string(from: date)
    }
}
