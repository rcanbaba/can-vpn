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

    enum CodingKeys: String, CodingKey {
        case servers, links, products, user
    }
}

// MARK: - Links
struct Links: Codable {
    let privacyURL, termsURL: String

    enum CodingKeys: String, CodingKey {
        case privacyURL = "privacy_url"
        case termsURL = "terms_url"
    }
}

// MARK: - Product
struct Product: Codable {
    let sku: String
    let isPromoted: Bool
    let tag: Int
    
    enum CodingKeys: String, CodingKey {
        case isPromoted = "is_promoted"
        case sku, tag
    }
}

// MARK: - Duration
struct Duration: Codable {
    let type: String
    let value: Int
}

// MARK: - Server
struct Server: Codable {
    let id: String
    let type: Int
    let engine: Int
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

// MARK: - User
struct User: Codable {
    let sharedID: String
    var isSubscribed: Bool

    enum CodingKeys: String, CodingKey {
        case sharedID = "shared_id"
        case isSubscribed = "is_subscribed"
    }
}
