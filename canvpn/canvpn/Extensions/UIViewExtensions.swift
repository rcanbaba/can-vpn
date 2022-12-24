//
//  UIViewExtensions.swift
//  canvpn
//
//  Created by Can Babaoğlu on 24.12.2022.
//

import UIKit

extension UIView {
    
    // MARK: right to left languages check
    var isRTL: Bool { UIView.userInterfaceLayoutDirection(for: semanticContentAttribute) == .rightToLeft }
    
    // MARK: fade-in out animations
    func hideWithAnimation (compHandler: (() -> ())? = nil) {
        UIView.animate(withDuration: Constants.animationDuration, animations: {
            self.alpha = 0.0
        }) { (flag) in
            compHandler?()
        }
    }
    
    func showWithAnimation (compHandler: (() -> ())? = nil) {
        UIView.animate(withDuration: Constants.animationDuration, animations: {
            self.alpha = 1.0
        }) { (flag) in
            compHandler?()
        }
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat, borderColor: UIColor? = nil, borderWidth: CGFloat? = nil) {
        self.layer.mask = nil
        for layer in self.layer.sublayers ?? [] {
           if layer.isKind(of: CAShapeLayer.self) {
              layer.removeFromSuperlayer()
           }
        }
        
        let path = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))

        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask

        let borderPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let borderLayer = CAShapeLayer()
        borderLayer.path = borderPath.cgPath
        borderLayer.lineWidth = borderWidth ?? 0
        borderLayer.strokeColor = borderColor?.cgColor ?? UIColor.clear.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.frame = self.bounds
        self.layer.addSublayer(borderLayer)
    }
    
    func addBorder(_ edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        let subview = UIView()
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.backgroundColor = color
        self.addSubview(subview)
        switch edge {
        case .top, .bottom:
            subview.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
            subview.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
            subview.heightAnchor.constraint(equalToConstant: thickness).isActive = true
            if edge == .top {
                subview.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
            } else {
                subview.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
            }
        case .left, .right:
            subview.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
            subview.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
            subview.widthAnchor.constraint(equalToConstant: thickness).isActive = true
            if edge == .left {
                subview.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
            } else {
                subview.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
            }
        default:
            break
        }
    }
    
}


