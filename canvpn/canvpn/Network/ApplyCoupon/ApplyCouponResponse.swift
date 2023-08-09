//
//  ApplyCouponResponse.swift
//  canvpn
//
//  Created by Can Babaoğlu on 9.08.2023.
//

import Foundation

// MARK: - ApplyCouponResponse
struct ApplyCouponResponse: Codable {
    let products: [Product]
    
    enum CodingKeys: String, CodingKey {
        case products
    }
}
