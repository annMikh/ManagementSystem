//
//  AlertComment.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 11.04.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation
import UIKit

final class AlertComment {

    var textField : UITextField?
    
    func alert(done: @escaping (UIAlertAction) -> (Void)) {
        let alert = UIAlertController(title: "New Comment", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Enter your comment"
        }
        
        self.textField = alert.textFields![0] as UITextField

        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: done))
        showAlert(alert: alert)
    }
    
    private func topMostViewController() -> UIViewController? {
       guard let rootController = keyWindow()?.rootViewController else {
            return nil
       }
       return topMostViewController(for: rootController)
    }
    
    private func topMostViewController(for controller: UIViewController) -> UIViewController {
        if let presentedController = controller.presentedViewController {
            
            return topMostViewController(for: presentedController)
            
        } else if let navigationController = controller as? UINavigationController {
            
            guard let topController = navigationController.topViewController else {
                return navigationController
            }
            return topMostViewController(for: topController)
            
        } else if let tabController = controller as? UITabBarController {
            
            guard let topController = tabController.selectedViewController else {
                return tabController
            }
            
            return topMostViewController(for: topController)
        }
        return controller
    }
    
    
    private func keyWindow() -> UIWindow? {
        return UIApplication
                    .shared.connectedScenes
                    .filter {$0.activationState == .foregroundActive}
                    .compactMap {$0 as? UIWindowScene}
                    .first?.windows.filter {$0.isKeyWindow}.first
    }
    
    
    private func showAlert(alert: UIAlertController) {
       if let controller = topMostViewController() {
           controller.present(alert, animated: true)
       }
    }
    
}
