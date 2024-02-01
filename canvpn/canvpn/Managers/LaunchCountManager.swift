//
//  LaunchCountManager.swift
//  canvpn
//
//  Created by Can Babaoğlu on 9.09.2023.
//

import Foundation

class LaunchCountManager {
    
    static let shared = LaunchCountManager()
    
    private let launchCountKey = "launchCountKey"
    private let islandingShownKey = "islandingShownKey"
    
    private init() {}
    
    public func incrementLaunchCount() {
        var count = UserDefaults.standard.integer(forKey: launchCountKey)
        count += 1
        UserDefaults.standard.set(count, forKey: launchCountKey)
    }
    
    public func shouldShowGetFreePopup() -> Bool {
        let count = UserDefaults.standard.integer(forKey: launchCountKey)
        guard let emailBannerSettings = SettingsManager.shared.settings?.interface.showEmailBanner,
              emailBannerSettings.enabled else {
            return false
        }
        return count >= emailBannerSettings.count
    }
    
    public func shouldShowLanding() -> Bool {
        let islandingShown = UserDefaults.standard.bool(forKey: islandingShownKey)
        return !islandingShown
    }
    
    public func resetLaunchCount() {
        UserDefaults.standard.set(0, forKey: launchCountKey)
    }
    
    public func landingFlowCompleted() {
        UserDefaults.standard.set(true, forKey: islandingShownKey)
    }
}
