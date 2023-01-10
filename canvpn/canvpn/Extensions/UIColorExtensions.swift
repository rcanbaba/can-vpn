//
//  UIColorExtensions.swift
//  canvpn
//
//  Created by Can Babaoğlu on 24.12.2022.
//

import UIKit

// MARK: UI Color Hex int
extension UIColor {
    convenience init(_ hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

extension UIColor {
    struct Text {
        static let white = UIColor("FFFFFF")
        static let dark = UIColor("050A30")
    }
    struct Custom {
        static let orange = UIColor("FD6043")
        static let green = UIColor("38D980")
        static let dark = UIColor("050A30")
        static let cellBg = UIColor("00111E").withAlphaComponent(0.5)
        static let selectedCellBg = UIColor("38D980").withAlphaComponent(0.5)
    }
    
}
