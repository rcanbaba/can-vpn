//
//  Helper.swift
//  canvpn
//
//  Created by Can Babaoğlu on 20.12.2022.
//

import UIKit
import NetworkExtension

enum ConnectionState {
    case initial
    case disconnected
    case connecting
    case connected
    case disconnecting
}

extension ConnectionState {
    
    func getText() -> String {
        switch self {
        case .initial:
            return "connect_key".localize()
        case .connecting:
            return "connecting_key".localize()
        case .connected:
            return "connected_key".localize()
        case .disconnecting:
            return "disconnecting_key".localize()
        case .disconnected:
            return "disconnected_key".localize()
        }
    }
    
    func getUserInteraction() -> Bool {
        switch self {
        case .initial, .connected, .disconnected:
            return true
        case .connecting, .disconnecting:
            return false
        }
    }
    
    func getUIColor() -> UIColor {
        switch self {
        case .initial:
            return UIColor.Custom.orange
        case .disconnected:
            return UIColor.Custom.orange
        case .connecting:
            return UIColor.Custom.gray
        case .connected:
            return UIColor.Custom.green
        case .disconnecting:
            return UIColor.Custom.gray
        }
    }
    
    func getBgWorldUIImage() -> UIImage? {
        switch self {
        case .initial:
            return UIImage(named: "world-map-orange")
        case .disconnected:
            return UIImage(named: "world-map-orange")
        case .connecting:
            return UIImage(named: "world-map-gray")
        case .connected:
            return UIImage(named: "world-map-green")
        case .disconnecting:
            return UIImage(named: "world-map-gray")
        }
    }
    
    func getCenterButtonUIImage() -> UIImage? {
        switch self {
        case .initial:
            return UIImage(named: "power-orange-button")?.withRenderingMode(.alwaysOriginal)
        case .disconnected:
            return UIImage(named: "power-orange-button")?.withRenderingMode(.alwaysOriginal)
        case .connecting:
            return UIImage(named: "power-gray-button")?.withRenderingMode(.alwaysOriginal)
        case .connected:
            return UIImage(named: "power-green-button")?.withRenderingMode(.alwaysOriginal)
        case .disconnecting:
            return UIImage(named: "power-gray-button")?.withRenderingMode(.alwaysOriginal)
        }
    }
    
    func getTopLogoImage() -> UIImage? {
        switch self {
        case .initial:
            return UIImage(named: "top-logo-orange")
        case .disconnected:
            return UIImage(named: "top-logo-orange")
        case .connecting:
            return UIImage(named: "top-logo-gray")
        case .connected:
            return UIImage(named: "top-logo-green")
        case .disconnecting:
            return UIImage(named: "top-logo-gray")
        }
    }
    
    func getTimeIsVisible() -> Bool {
        switch self {
        case .connected:
            return true
        case .initial:
            return false
        case .disconnected:
            return false
        case .connecting:
            return false
        case .disconnecting:
            return false
        }
    }
    
}

enum SignalUILevel: Int {
    case slow = 1
    case medium = 2
    case fast = 3
    case fastFast = 4
    case superFast = 5
}

extension SignalUILevel {
    func getSignalTextColor() -> UIColor {
        switch self {
        case .slow:
            .red
        case .medium:
            .orange
        case .fast:
            UIColor("2BBC28")
        case .fastFast:
            UIColor("2BBC28")
        case .superFast:
            UIColor("00B2FF")
        }
    }
    
    func getSignalText() -> String {
        switch self {
        case .slow:
            "speed_slow".localize()
        case .medium:
            "speed_average".localize()
        case .fast, .fastFast:
            "speed_fast".localize()
        case .superFast:
            "speed_super".localize()
        }
    }
    
}

enum SignalLevel: Int {
    case low = 1
    case medium = 2
    case good = 3
    case perfect = 4
}

extension SignalLevel {
    func getSignalImage() -> UIImage? {
        switch self {
        case .low:
            return UIImage(named: "signal-1-orange-icon")
        case .medium:
            return UIImage(named: "signal-2-yellow-icon")
        case .good:
            return UIImage(named: "signal-3-green-icon")
        case .perfect:
            return UIImage(named: "signal-4-green-icon")
        }
    }
    
    func getSignalEnumForUI() -> SignalUILevel {
        switch self {
        case .low:
            return .slow
        case .medium:
            return .medium
        case .good:
            return .fast
        case .perfect:
            return Bool.random() ? .fastFast : .superFast
        }
    }
}

enum PremiumFeatureType {
    case anonymous
    case fast
    case location
    case secure
    case noAds
}

extension PremiumFeatureType {
    func getImage() -> UIImage? {
        switch self {
        case .anonymous:
            return UIImage(named: "premium-hat-icon")
        case .fast:
            return UIImage(named: "premium-rocket-icon")
        case .noAds:
            return UIImage(named: "premium-minus-icon")
        case .secure:
            return UIImage(named: "premium-secure-icon")
        case .location:
            return UIImage(named: "premium-minus-icon")
        }
    }
    
    func getTitle() -> String? {
        switch self {
        case .anonymous:
            return "premium_title_1".localize()
        case .fast:
            return "premium_title_2".localize()
        case .location:
            return "premium_title_3".localize()
        case .secure:
            return "premium_title_4".localize()
        case .noAds:
            return "premium_title_5".localize()
        }
    }
    
    func getDescription() -> String? {
        switch self {
        case .anonymous:
            return "premium_desc_1".localize()
        case .fast:
            return "premium_desc_2".localize()
        case .location:
            return "premium_desc_3".localize()
        case .secure:
            return "premium_desc_4".localize()
        case .noAds:
            return "premium_desc_5".localize()
        }
    }
    
    func getFreeCheck() -> Bool {
        switch self {
        case .anonymous:
            return true
        case .fast:
            return false
        case .noAds:
            return false
        case .secure:
            return true
        case .location:
            return false
        }
    }
}

extension Int {
    func isPremium() -> Bool {
        if self == 2 {
            return true
        } else {
            return false
        }
    }
    
}

extension NEVPNStatus {
    func getConnectionState() -> ConnectionState {
        switch self {
        case .invalid:
            return .disconnected
        case .disconnected:
            return .disconnected
        case .connecting:
            return .connecting
        case .connected:
            return .connected
        case .reasserting:
            return .connecting
        case .disconnecting:
            return .disconnecting
        @unknown default:
            fatalError()
        }
    }
}
