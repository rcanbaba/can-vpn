//
//  SideMenuHelper.swift
//  canvpn
//
//  Created by Can Babaoğlu on 28.10.2023.
//

import UIKit

enum MenuItemType {
    case accountInformation // ip adress - subs type
    case restoreSubscriptions // yönlendir
    case subscriptionHistory // VC yarat göster
    case usePromoCode // yönlendir orda aç
    case checkSecurity // ayrı bir popup
    case rateUs // ayrı rating popup
    case feedback // WEB
    case faq // WEB
    case aboutUs // WEB
    case whatIsMyIP // WEB
    case whatIsMySpeed // WEB
    case shareUs // Share Sheet
    case settings // VC -> language
    case blankItem // Spacer
    case version // version
    case staySecureWithLove // Motto

    func getImage() -> UIImage? {
        switch self {
        case .accountInformation:
            return UIImage(systemName: "person.crop.circle.fill")?.withTintColor(UIColor.Custom.gray, renderingMode: .alwaysOriginal)
        case .restoreSubscriptions:
            return UIImage(systemName: "arrow.clockwise.circle.fill")?.withTintColor(UIColor.Custom.green, renderingMode: .alwaysOriginal)
        case .subscriptionHistory:
            return UIImage(systemName: "clock.arrow.circlepath")?.withTintColor(UIColor.Custom.green, renderingMode: .alwaysOriginal)
        case .usePromoCode:
            return UIImage(systemName: "qrcode")?.withTintColor(UIColor.Custom.green, renderingMode: .alwaysOriginal)
        case .aboutUs:
            return UIImage(systemName: "info.circle.fill")?.withTintColor(UIColor.Custom.orange, renderingMode: .alwaysOriginal)
        case .checkSecurity:
            return UIImage(systemName: "shield.lefthalf.fill")?.withTintColor(UIColor.Custom.orange, renderingMode: .alwaysOriginal)
        case .rateUs:
            return UIImage(systemName: "star.circle.fill")?.withTintColor(UIColor.Custom.green, renderingMode: .alwaysOriginal)
        case .whatIsMyIP:
            return UIImage(systemName: "questionmark.diamond.fill")?.withTintColor(UIColor.Custom.orange, renderingMode: .alwaysOriginal)
        case .whatIsMySpeed:
            return UIImage(systemName: "gauge")?.withTintColor(UIColor.Custom.orange, renderingMode: .alwaysOriginal)
        case .settings:
            return UIImage(systemName: "slider.horizontal.3")?.withTintColor(UIColor.Custom.gray, renderingMode: .alwaysOriginal)
        case .feedback:
            return UIImage(systemName: "pencil.tip")?.withTintColor(UIColor.Custom.orange, renderingMode: .alwaysOriginal)
        case .faq:
            return UIImage(systemName: "questionmark.bubble.fill")?.withTintColor(UIColor.Custom.orange, renderingMode: .alwaysOriginal)
        case .shareUs:
            return UIImage(systemName: "arrow.up.forward.circle.fill")?.withTintColor(UIColor.Custom.green, renderingMode: .alwaysOriginal)
        case .staySecureWithLove, .blankItem, .version:
            return nil // or return a specific image if needed
        }
    }
    
    func getTitle() -> String {
        switch self {
        case .accountInformation: return "Account"
        case .restoreSubscriptions: return "Restore Subscriptions"
        case .subscriptionHistory: return "Subscription History"
        case .usePromoCode: return "Use Promo Code"
        case .checkSecurity: return "Check Security"
        case .rateUs: return "Rate Us"
        case .feedback: return "Feedback"
        case .faq: return "F.A.Q"
        case .aboutUs: return "About Us"
        case .whatIsMyIP: return "What is my ip"
        case .whatIsMySpeed: return "What is my speed"
        case .shareUs: return "Share Us"
        case .settings: return "Settings"
        case .blankItem: return ""
        case .version: return "Version \(Constants.appBuild)"
        case .staySecureWithLove: return "Stay secure with Love"
        }
    }
    
    func getURLString() -> String {
        switch self {
        case .feedback: return Constants.appContactUsURLString
        case .faq: return Constants.appFAQPageURLString
        case .aboutUs: return Constants.appWebPageURLString
        case .whatIsMyIP: return "https://ilovevpn.app/what-is-my-ip/"
        case .whatIsMySpeed: return "https://ilovevpn.app/how-fast-my-internet/"
        default: return ""
        }
    }
}
