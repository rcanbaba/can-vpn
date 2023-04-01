//
//  CredentialResponse.swift
//  canvpn
//
//  Created by Can Babaoğlu on 1.04.2023.
//

import Foundation

// MARK: - Credential
struct Credential: Codable {
    let id: String
    let engine: Int
    let configuration: Configuration
}

// MARK: - Configuration
struct Configuration: Codable {
    let interface: Interface
    let peer: Peer
}

// MARK: - Interface
struct Interface: Codable {
    let privateKey: String
    let address: [String]
    let mtu: Int
    let dns: [String]

    enum CodingKeys: String, CodingKey {
        case privateKey = "private_key"
        case address, mtu, dns
    }
}

// MARK: - Peer
struct Peer: Codable {
    let presharedKey, publicKey: String
    let allowedIPS: [String]
    let endpoint: String

    enum CodingKeys: String, CodingKey {
        case presharedKey = "preshared_key"
        case publicKey = "public_key"
        case allowedIPS = "allowed_ips"
        case endpoint
    }
}
