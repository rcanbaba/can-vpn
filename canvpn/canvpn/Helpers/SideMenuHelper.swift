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
        case .accountInformation: return "account_side_title".localize()
        case .restoreSubscriptions: return "restore_subs_side_title".localize()
        case .subscriptionHistory: return "subs_history_side_title".localize()
        case .usePromoCode: return "promo_code_side_title".localize()
        case .checkSecurity: return "security_side_title".localize()
        case .rateUs: return "rate_side_title".localize()
        case .feedback: return "feedback_side_title".localize()
        case .faq: return "faq_side_title".localize()
        case .aboutUs: return "about_side_title".localize()
        case .whatIsMyIP: return "ip_side_title".localize()
        case .whatIsMySpeed: return "speed_side_title".localize()
        case .shareUs: return "share_side_title".localize()
        case .settings: return "language_settings_key".localize()
        case .blankItem: return ""
        case .version: return "version_side_title".localize() + " \(Constants.appBuild)"
        case .staySecureWithLove: return "motto_side_title".localize()
        }
    }
    
    func getURLString() -> String {
        switch self {
        case .feedback: return Constants.appContactUsURLString
        case .faq: return Constants.appFAQPageURLString
        case .aboutUs: return Constants.appWebPageURLString
        case .whatIsMyIP: return Constants.appIPTestURLString
        case .whatIsMySpeed: return Constants.appSpeedTestURLString
        default: return ""
        }
    }
}
