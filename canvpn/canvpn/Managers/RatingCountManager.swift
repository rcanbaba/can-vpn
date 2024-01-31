//
//  RatingCountManager.swift
//  canvpn
//
//  Created by Can Babaoğlu on 31.01.2024.
//

import Foundation

class RatingCountManager {
    
    static let shared = RatingCountManager()
    
    private let ratingLaunchCountKey = "ratingCounterKey"
    private let ratingPremiumPageCountKey = "ratingPremiumPageCountKey"
    private let ratingConnectCountKey = "ratingConnectCountKey"
    private let ratingWebCountKey = "ratingWebCountKey"
    
    private let isUserRatedAlready = "isRatingShown"
    private let isUserGiveLowRate = "isGiveBelowRate"
    
    private let launchCountThreshold: Int = 4
    private let premiumPageCountThreshold: Int = 3
    private let connectCountThreshold: Int = 5
    private let webCountThreshold: Int = 2
    
    private init() {}
    
    public func incrementLaunchCount() {
        var count = UserDefaults.standard.integer(forKey: ratingLaunchCountKey)
        count += 1
        UserDefaults.standard.set(count, forKey: ratingLaunchCountKey)
    }
    
    public func incrementPremiumPageCount() {
        var count = UserDefaults.standard.integer(forKey: ratingPremiumPageCountKey)
        count += 1
        UserDefaults.standard.set(count, forKey: ratingPremiumPageCountKey)
    }
    
    public func incrementConnectCount() {
        var count = UserDefaults.standard.integer(forKey: ratingConnectCountKey)
        count += 1
        UserDefaults.standard.set(count, forKey: ratingConnectCountKey)
    }
    
    public func incrementWebPresentedCount() {
        var count = UserDefaults.standard.integer(forKey: ratingWebCountKey)
        count += 1
        UserDefaults.standard.set(count, forKey: ratingWebCountKey)
    }
    
    public func shouldShowPopup() -> Bool {
        let isUserRated = UserDefaults.standard.bool(forKey: isUserRatedAlready)
        if isUserRated { return false }
        
        if (SettingsManager.shared.settings?.isInReview ?? true ) { return false }
        
        let userRatedLow = UserDefaults.standard.bool(forKey: isUserGiveLowRate)
        var lowRateFactor: Int = 1
        if userRatedLow { lowRateFactor = 2 }
        
        let launchCount = UserDefaults.standard.integer(forKey: ratingLaunchCountKey)
        let premiumPageCount = UserDefaults.standard.integer(forKey: ratingPremiumPageCountKey)
        let connectCount = UserDefaults.standard.integer(forKey: ratingConnectCountKey)
        let webCount = UserDefaults.standard.integer(forKey: ratingWebCountKey)
        
        return launchCount >= launchCountThreshold * lowRateFactor ||
               premiumPageCount >= premiumPageCountThreshold * lowRateFactor ||
               connectCount >= connectCountThreshold * lowRateFactor ||
               webCount >= webCountThreshold * lowRateFactor
    }
    
    public func userGaveHighRating() {
        UserDefaults.standard.set(true, forKey: isUserRatedAlready)
    }
    
    public func userGaveLowRating() {
        UserDefaults.standard.set(true, forKey: isUserGiveLowRate)
        resetAllCount()
    }
    
    public func resetAllCount() {
        UserDefaults.standard.set(0, forKey: ratingLaunchCountKey)
        UserDefaults.standard.set(0, forKey: ratingPremiumPageCountKey)
        UserDefaults.standard.set(0, forKey: ratingConnectCountKey)
        UserDefaults.standard.set(0, forKey: ratingWebCountKey)
    }
    
}
