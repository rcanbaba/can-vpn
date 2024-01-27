//
//  CALayerExtensions.swift
//  canvpn
//
//  Created by Can Babaoğlu on 24.12.2022.
//

import UIKit

extension CALayer {
    func applySketchShadow(
        color: UIColor = .black,
        alpha: Float = 0.35,
        x: CGFloat = 0,
        y: CGFloat = 0,
        blur: CGFloat = 4,
        spread: CGFloat = 0)
    {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
    
    func applySubscriptionShadow(
        color: UIColor = .black,
        alpha: Float = 0.4,
        x: CGFloat = 0,
        y: CGFloat = 0,
        blur: CGFloat = 4,
        spread: CGFloat = 0)
    {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}
