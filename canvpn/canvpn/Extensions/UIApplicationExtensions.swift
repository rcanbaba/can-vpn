//
//  UIApplicationExtensions.swift
//  canvpn
//
//  Created by Can Babaoğlu on 3.04.2023.
//

import UIKit

// MARK: - UIApplication extensions
extension UIApplication {
    
    class func getTopViewController(base: UIViewController? = getMainWindow()?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
            
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)
            
        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
    
    class func getMainWindow () -> UIWindow? {
        
        let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        
        return window
    }
    
    
}
