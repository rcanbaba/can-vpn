//
//  Constants.swift
//  canvpn
//
//  Created by Can Babaoğlu on 24.12.2022.
//

import Foundation
import UIKit

struct Constants {
    
    static let appName = "ilovevpn"
    static let appVisibleName = "iLove VPN"
    static let OSType = "ios"
    static let appBuild = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown"
    static let osVersion = UIDevice.current.systemVersion
    static var langCode = KeyValueStorage.languageCode ?? Locale.preferredLocale().languageCode?.lowercased() ?? "unknown"
    
    static var originalIP = ""
    
    static let idfv = KeychainManager.shared.getDeviceIdentifierFromKeychain()
    
    static let baseURL = "https://api.ilovevpn.co"
    
    static let appNavBarName = "I Love VPN"
    static let vpnListingName = "iLoveVPN"
    static let animationDuration: Double = 0.3
    
    // app url strings
    static let appWebPageURLString = "https://ilovevpn.app/"
    static let appPrivacyPolicyPageURLString = "https://ilovevpn.app/privacy-policy/"
    static let appTermsOfServicePageURLString = "https://ilovevpn.app/terms-of-service/"
    static let appFAQPageURLString = "https://ilovevpn.app/frequently-asked-questions/"
    static let appContactUsURLString = "https://ilovevpn.app/contact-us/"
    static let appIPTestURLString = "https://utils.ilovevpn.co/what-is-my-ip"
    static let appSpeedTestURLString = "https://utils.ilovevpn.co/speed-test"
    static let shareUsURLString = "https://lvvpn.link/app"

    static let appContactUsMailString = "info@ilovevpn.app"
    
    static let getFreeAnimationDuration: Double = 7.0
    
    static let requestTimeout = TimeInterval(5)
}
