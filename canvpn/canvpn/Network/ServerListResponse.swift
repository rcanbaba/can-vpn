//
//  ServerListResponse.swift
//  canvpn
//
//  Created by Can Babaoğlu on 23.12.2022.
//

import Foundation

struct SearchCompanyItem: Codable {
    let companyID, name: String?

    enum CodingKeys: String, CodingKey {
        case companyID = "company_id"
        case name
    }
}

typealias SearchCompanyResponse = [SearchCompanyItem]
