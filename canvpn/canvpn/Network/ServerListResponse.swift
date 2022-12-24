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
