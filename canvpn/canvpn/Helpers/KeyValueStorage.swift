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
        case pushNotificationFCMToken = "kPushNotificationFCMToken"
        case lastConnectedLocation = "lastConnectedLocation"
        case creationDate = "creationDate"
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
        } set(newValue) {
            userDefaults.set(newValue, forKey: Keys.deviceId.rawValue)
        }
    }
    
    static var pushNotificationFCMToken: String? {
        get {
            return userDefaults.string(forKey: Keys.pushNotificationFCMToken.rawValue)
        } set(newValue) {
            userDefaults.set(newValue, forKey: Keys.pushNotificationFCMToken.rawValue)
        }
    }
    
    static var lastConnectedLocation: Server? {
        get {
            if let data = UserDefaults.standard.data(forKey: Keys.lastConnectedLocation.rawValue),
               let server = try? JSONDecoder().decode(Server.self, from: data) {
                return server
            }
            return nil
        }
        set(newValue) {
            if let encoded = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: Keys.lastConnectedLocation.rawValue)
            }
        }
    }
    
    static var creationDate: String {
        get {
            if let value = userDefaults.string(forKey: Keys.creationDate.rawValue) {
                return value
            } else {
                let value = UUID().uuidString
                KeyValueStorage.creationDate = value
                return value
            }
        } set(newValue) {
            userDefaults.set(newValue, forKey: Keys.creationDate.rawValue)
        }
    }
}

