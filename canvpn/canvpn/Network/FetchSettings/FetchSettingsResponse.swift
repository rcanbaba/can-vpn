//
//  FetchSettingsResponse.swift
//  canvpn
//
//  Created by Can Babaoğlu on 7.05.2023.
//

import Foundation

typealias Settings = SettingsResponse

// MARK: - SettingsResponse
struct SettingsResponse: Codable {
    var user: User
    let servers: [Server]
    let links: Links
    let products: [Product]
    let interface: UserInterface
    let isInReview: Bool
    let appUpdate: AppUpdate?
    let text: Text

    enum CodingKeys: String, CodingKey {
        case user, servers, links, products, interface
        case isInReview = "is_in_review"
        case appUpdate = "app_update"
        case text
    }
}

// MARK: - AppUpdate
struct AppUpdate: Codable {
    let isForced: Bool
    let message, title, confirmText, cancelText: String
    let updateURL: String

    enum CodingKeys: String, CodingKey {
        case isForced = "is_forced"
        case message, title
        case confirmText = "confirm_text"
        case cancelText = "cancel_text"
        case updateURL = "update_url"
    }
}

// MARK: - Interface
struct UserInterface: Codable {
    let showCoupon, showPurchase: Bool
    let showReview: ShowReview
    let showEmailBanner: ShowEmailBanner

    enum CodingKeys: String, CodingKey {
        case showCoupon = "show_coupon"
        case showPurchase = "show_purchase"
        case showReview = "show_review"
        case showEmailBanner = "show_email_banner"
    }
}

// MARK: - ShowEmailBanner
struct ShowEmailBanner: Codable {
    let enabled: Bool
    let count: Int
    let text: String
}

// MARK: - ShowReview
struct ShowReview: Codable {
    let enabled: Bool
    let count: Int
}

// MARK: - Links
struct Links: Codable {
    let privacyURL, termsURL, subscriptionTermsURL: String

    enum CodingKeys: String, CodingKey {
        case privacyURL = "privacy_url"
        case termsURL = "terms_url"
        case subscriptionTermsURL = "subscription_terms_url"
    }
}

// MARK: - Product
struct Product: Codable {
    let sku: String
    let isPromoted, isBestOffer: Bool
    let discount: Int

    enum CodingKeys: String, CodingKey {
        case sku
        case isPromoted = "is_promoted"
        case isBestOffer = "is_best_offer"
        case discount
    }
}

// MARK: - Server
struct Server: Codable {
    let id: String
    let type, engine: Int
    let url: String
    let location: Location
    let ping: Int
}

// MARK: - Location
struct Location: Codable {
    let countryCode, city: String

    enum CodingKeys: String, CodingKey {
        case countryCode = "country_code"
        case city
    }
}

// MARK: - Text
struct Text: Codable {
    let subscriptionTermsDetail: String

    enum CodingKeys: String, CodingKey {
        case subscriptionTermsDetail = "subscription_terms_detail"
    }
}

// MARK: - User
struct User: Codable {
    let sharedID: String
    let subscriptionType: Int
    let isInGracePeriod: Bool
    var isSubscribed: Bool

    enum CodingKeys: String, CodingKey {
        case sharedID = "shared_id"
        case subscriptionType = "subscription_type"
        case isSubscribed = "is_subscribed"
        case isInGracePeriod = "is_in_grace_period"
    }
}
