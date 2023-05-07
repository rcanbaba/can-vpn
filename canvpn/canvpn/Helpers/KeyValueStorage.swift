//
//  KeyValueStorage.swift
//  canvpn
//
//  Created by Can Babaoğlu on 7.05.2023.
//

import Foundation


class KeyValueStorage {
    
    private enum Keys: String {
        case installationId = "installationId"
        case deviceId = "deviceId"
        
        
    }
    
    static let userDefaults = UserDefaults.standard
    
    static var installationId: String {
        get {
            if let value = userDefaults.string(forKey: Keys.installationId.rawValue) {
                return value
            } else {
                let value = UUID().uuidString
                KeyValueStorage.installationId = value
                return value
            }
        } set(newValue) {
            userDefaults.set(newValue, forKey: Keys.installationId.rawValue)
        }
    }
    
    static var deviceId: String? {
        get {
            return userDefaults.string(forKey: Keys.deviceId.rawValue)
        }
        set(newValue) {
            userDefaults.set(newValue, forKey: Keys.deviceId.rawValue)
        }
    }
    
    
}

