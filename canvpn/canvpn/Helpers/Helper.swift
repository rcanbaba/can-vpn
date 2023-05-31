//
//  Helper.swift
//  canvpn
//
//  Created by Can Babaoğlu on 20.12.2022.
//

import UIKit

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
            return UIImage(named: "power-orange-button")
        case .disconnected:
            return UIImage(named: "power-orange-button")
        case .connecting:
            return UIImage(named: "power-gray-button")
        case .connected:
            return UIImage(named: "power-green-button")
        case .disconnecting:
            return UIImage(named: "power-gray-button")
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
}

enum PremiumFeatureType {
    case anonymous
    case fast
    case noAds
    case secure
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
        }
    }
    
    func getTitle() -> String? {
        switch self {
        case .anonymous:
            return "premium_title_1".localize()
        case .fast:
            return "premium_title_2".localize()
        case .noAds:
            return "premium_title_3".localize()
        case .secure:
            return "premium_title_4".localize()
        }
    }
    
    func getDescription() -> String? {
        switch self {
        case .anonymous:
            return "premium_desc_1".localize()
        case .fast:
            return "premium_desc_2".localize()
        case .noAds:
            return "premium_desc_3".localize()
        case .secure:
            return "premium_desc_4".localize()
        }
    }
    
}

extension Int {
    func isPremiums() -> Bool {
        if self == 2 {
            return true
        } else {
            return false
        }
    }
    
}
