//
//  ATTrackingManager.swift
//  canvpn
//
//  Created by Can Babaoğlu on 10.08.2023.
//

import AppTrackingTransparency
import AdSupport

class TrackingManager {
    
    static let shared = TrackingManager()
    
    private init() {} // Private initializer to ensure only one instance is created

    func requestTrackingPermission(completion: @escaping (String) -> Void) {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                switch status {
                case .authorized:  // User has granted permission to track
                    let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                    completion("authorized")
                case .denied: // User has denied permission to track
                    completion("denied")
                case .restricted, .notDetermined: // Handle accordingly
                    completion("restricted or notDetermined")
                @unknown default:
                    completion("unknown")
                }
            })
        } else {
            // Handle scenario for iOS versions < 14 or provide an alternative mechanism
            completion("iOS version < 14")
        }
    }
}
