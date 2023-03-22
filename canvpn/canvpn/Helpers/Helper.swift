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

enum SignalLevel {
    case low
    case medium
    case good
    case perfect
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
