//
//  ServerListResponse.swift
//  canvpn
//
//  Created by Can Babaoğlu on 23.12.2022.
//

import Foundation

struct SearchCompanyItem: Codable {
    let data, error: String?

    enum CodingKeys: String, CodingKey {
        case data = "data"
        case error = "error"
    }
}

typealias SearchCompanyResponse = [SearchCompanyItem]

// MARK: - Welcome
struct Welcome: Codable {
    let servers: [Server]
}

// MARK: - Server
struct Server: Codable {
    let id: String
    let type, engine: Int
    let connection: Connection
    let location: Location
}

// MARK: - Connection
struct Connection: Codable {
    let host, port: String
}

// MARK: - Location
struct Location: Codable {
    let countryCode, city: String

    enum CodingKeys: String, CodingKey {
        case countryCode = "country_code"
        case city
    }
}
