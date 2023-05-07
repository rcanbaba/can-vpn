//
//  FetchSettingsResponse.swift
//  canvpn
//
//  Created by Can Babaoğlu on 7.05.2023.
//

import Foundation

// MARK: - Settings
struct Settings: Codable {
    let sharedID: String
    let servers: [Server]
    let links: Links
    let products: [Product]

    enum CodingKeys: String, CodingKey {
        case sharedID = "shared_id"
        case servers, links, products
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
    let duration: Duration
    let tag: Int
}

// MARK: - Duration
struct Duration: Codable {
    let type: String
    let value: Int
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

