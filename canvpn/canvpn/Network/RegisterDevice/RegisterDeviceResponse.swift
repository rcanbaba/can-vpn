//
//  RegisterDeviceResponse.swift
//  canvpn
//
//  Created by Can Babaoğlu on 7.05.2023.
//

import Foundation

// MARK: - RegisterResponse
struct RegisterResponse: Codable {
    let deviceID: String

    enum CodingKeys: String, CodingKey {
        case deviceID = "device_id"
    }
}
