//
//  SideMenuHelper.swift
//  canvpn
//
//  Created by Can Babaoğlu on 28.10.2023.
//

import UIKit

enum MenuItem {
    case accountInformation
    case restoreSubscriptions
    case subscriptionHistory
    case usePromoCode
    case checkSecurity
    case rateUs
    case feedback
    case faq
    case aboutUs
    case whatIsMyIP
    case whatIsMySpeed
    case shareUs
    case settings
    case blankItem
    case version
    case staySecureWithLove

    func getImage() -> UIImage? {
        switch self {
        case .accountInformation: return UIImage(named: "accountIcon")
        case .restoreSubscriptions: return UIImage(named: "systemIcon")
        case .subscriptionHistory, .usePromoCode, .aboutUs: return UIImage(named: "aboutIcon")
        case .checkSecurity, .rateUs, .whatIsMyIP, .whatIsMySpeed, .settings, .blankItem, .version: return UIImage(named: "purchaseIcon")
        case .feedback, .faq, .shareUs: return UIImage(named: "feedbackIcon")
        case .staySecureWithLove: return nil // or return a specific image if needed
        }
    }
    
    func getTitle() -> String {
        switch self {
        case .accountInformation: return "Account Information"
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
        case .version: return "Version 1.0.1"
        case .staySecureWithLove: return "Stay secure with Love"
        }
    }
}
