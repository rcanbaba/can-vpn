//
//  GetIPAddressResponse.swift
//  canvpn
//
//  Created by Can Babaoğlu on 30.05.2023.
//

import Foundation

typealias IPAddress = IPAddressResponse

// MARK: - GetIPAddressResponse
struct IPAddressResponse: Codable {
    let ipAddress: String

    enum CodingKeys: String, CodingKey {
        case ipAddress = "ip_address"
    }
}
