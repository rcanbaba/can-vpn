//
//  ServerListResponse.swift
//  canvpn
//
//  Created by Can Babaoğlu on 23.12.2022.
//

import Foundation

// MARK: - ServerList
struct ServerList: Codable {
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
