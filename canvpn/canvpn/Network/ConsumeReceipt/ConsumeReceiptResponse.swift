//
//  ConsumeReceiptResponse.swift
//  canvpn
//
//  Created by Can Babaoğlu on 25.07.2023.
//

import Foundation

// MARK: - ConsumeReceiptResponse
struct ConsumeReceiptResponse: Codable {
    let success: Bool
    let user: User
}
