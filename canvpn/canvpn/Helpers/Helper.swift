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
            return "Connect"
        case .connecting:
            return "Connecting"
        case .connected:
            return "Connected"
        case .disconnecting:
            return "Disconnecting"
        case .disconnected:
            return "Disconnected"
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
            return "Anonymous"
        case .fast:
            return "Fast"
        case .noAds:
            return "Remove Ads"
        case .secure:
            return "Secure"
        }
    }
    
    func getDescription() -> String? {
        switch self {
        case .anonymous:
            return "Hide your ip with anonymous surfing"
        case .fast:
            return "Up to 1000 Mb/s bandwidth to explore"
        case .noAds:
            return "Enjoy the app without annoying ads"
        case .secure:
            return "Transfer traffic via encrypted tunnel"
        }
    }
    
}
