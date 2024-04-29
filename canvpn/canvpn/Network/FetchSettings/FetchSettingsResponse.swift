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
    let skus: [String]
    let interface: UserInterface
    var isInReview: Bool
    let appUpdate: AppUpdate?
    let text: Text
    let contactUs: ContactUs
    let landingProduct: Product
    let specialOffer: SpecialOffer

    enum CodingKeys: String, CodingKey {
        case user, servers, links, products, skus, interface, text
        case isInReview = "is_in_review"
        case appUpdate = "app_update"
        case contactUs = "contact_us"
        case landingProduct = "landing_product"
        case specialOffer = "special_offer"
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
    let showRateUs: ShowRateUs
    let showEmailBanner: ShowEmailBanner

    enum CodingKeys: String, CodingKey {
        case showCoupon = "show_coupon"
        case showPurchase = "show_purchase"
        case showRateUs = "show_rate_us"
        case showEmailBanner = "show_email_banner"
    }
}

// MARK: - ShowEmailBanner
struct ShowEmailBanner: Codable {
    let enabled: Bool
    let count: Int
    let text: String
    let dialog: Dialog
}

// MARK: - Dialog
struct Dialog: Codable {
    let title, description: String
}

// MARK: - ShowReview
struct ShowRateUs: Codable {
    let enabled: Bool
    let count: Int
}

// MARK: - Links
struct Links: Codable {
    let privacyURL, termsURL, subscriptionTermsURL, faqsURL: String

    enum CodingKeys: String, CodingKey {
        case privacyURL = "privacy_url"
        case termsURL = "terms_url"
        case subscriptionTermsURL = "subscription_terms_url"
        case faqsURL = "faqs_url"
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
    let categories: [Int]
}

// MARK: - Location
struct Location: Codable {
    let countryCode, city: String
    let latitude, longitude: Double

    enum CodingKeys: String, CodingKey {
        case countryCode = "country_code"
        case city, latitude, longitude
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

// MARK: - ContactUs
struct ContactUs: Codable {
    let subject, email: String
}

// MARK: - SpecialOffer
struct SpecialOffer: Codable {
    let product: Product
    let meta: Meta
}

// MARK: - Meta
struct Meta: Codable {
    let duration: Int
}
