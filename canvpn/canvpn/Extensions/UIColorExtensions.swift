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
        static let gray = UIColor("969696")
        static let dark = UIColor("050A30")
        static let cellBg = UIColor("00111E").withAlphaComponent(0.5)
        static let selectedCellBg = UIColor("38D980").withAlphaComponent(0.5)
        
        static let actionButtonShadow = UIColor("767676")
        
        static let goPreButtonGold = UIColor("FFD521")
        static let goPreGrayText = UIColor("323438").withAlphaComponent(0.8)
        static let goProButtonGradient1 = UIColor("FFD964")
        static let goProButtonGradient2 = UIColor("FF852C")
        static let goProFeatureTextGray = UIColor("B5AEBE")
        
        static let premiumBackGradientEnd = UIColor("FFD964")
        static let premiumBackGradientStart = UIColor("FFFFFF")
        
        static let offerButtonBorderOrange = UIColor("FF852C")
        static let offerButtonTextOrange = UIColor("FF852C")
        static let offerButtonBorderGray = UIColor("DADADA")
        static let offerButtonTextGray = UIColor("000000").withAlphaComponent(0.6)

        struct RatingPopup {
            static let description = UIColor("646464")
            static let viewBackground = UIColor("F6F6F6")
        }
    }
    
    struct Landing {
        static let backGradientStart = UIColor("FFFFFF")
        static let backGradientEnd = UIColor("FFF4EA")
        static let buttonGradientStart = UIColor("FFA341")
        static let buttonGradientEnd = UIColor("FD6143")
        static let titleText = UIColor("454545")
    }
    
    struct Subscription {
        static let featureTitleText = UIColor("5B5B5B")
        static let featureDescriptionText = UIColor("5B5B5B")
        static let reviewText = UIColor("5B5B5B")
        static let titleText = UIColor("454545")
        static let orangeText = UIColor("FFA341")
        static let subscribeButtonGreen = UIColor("15CF74")
        static let productSelectedBorder = UIColor("FFBD0E")
        static let bestBadgeBack = UIColor("FFBD0E")
        static let discountedBadgeBack = UIColor("38D980")
        static let overlayBackGradientStart = UIColor("FFF9F4")
        static let overlayBackGradientEnd = UIColor("FFF4EA")
        static let proTextGreen = UIColor("2BBC28")
        static let freeTextGray = UIColor("5B5B5B")
    }
    
    struct NewSubs {
        static let green = UIColor("38D980")
        static let dark = UIColor("050A30")
        static let gray = UIColor("969696")
        static let gold = UIColor("FFD600")
        static let darkerGreen = UIColor("009946")
        static let oldGray = UIColor("747474")
        static let gradierGreen = UIColor("01CA5D")
        
        static let orange = UIColor("FD6043")
        static let orangish = UIColor("FFAD9E")
        static let redder = UIColor("FC2700")
    }
    
}
