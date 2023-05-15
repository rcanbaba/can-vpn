//
//  UIViewControllerExtensions.swift
//  canvpn
//
//  Created by Can Babaoğlu on 15.05.2023.
//

import UIKit

extension UIViewController {
    public func printDebug(_ string: String) {
#if DEBUG
        print("💚: " + string)
#endif
    }
    
}
