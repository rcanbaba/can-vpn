//
//  Endpoints.swift
//  canvpn
//
//  Created by Can Babaoğlu on 7.05.2023.
//

import Foundation

public struct Endpoints {
    static let registerDevice = "/v1/devices"
    static let fetchSettings = "/v1/settings"
    static let getCredential = "/v1/connect"
    static let registerFCM = "/v1/devices/notification/fcm"
    static let registerAPNS = "/v1/devices/notification/apns"
    static let getIPAddress = "/v1/utils/ip_address"
    static let consumeReceipt = "/v1/inapp_purchase/app_store/consume"
    static let applyCoupon = "/v1/coupon/apply"
    static let generateCoupon = "/v1/coupon/generate"
}
