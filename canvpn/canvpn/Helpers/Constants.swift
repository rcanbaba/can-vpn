//
//  Constants.swift
//  canvpn
//
//  Created by Can Babaoğlu on 24.12.2022.
//

import Foundation
import UIKit

class Constants {
    
    static let appName = "ilovevpn"
    static let OSType = "ios"
    static let appBuild = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown"
    
    static let idfv = UIDevice.current.identifierForVendor?.uuidString
    
    static let baseURL = "http://100.26.161.159"
    
    static let appNavBarName = "I Love VPN"
    static let vpnListingName = "iLoveVPN"
    static let animationDuration = 0.3
    static let appWebPageURLString = "https://ilovevpn.app/"
    static let appPrivacyPolicyPageURLString = "https://ilovevpn.app/privacy-policy/"
    static let appTermsOfServicePageURLString = "https://ilovevpn.app/terms-of-service/"
}
