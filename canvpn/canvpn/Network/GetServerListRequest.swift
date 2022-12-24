//
//  GetServerListRequest.swift
//  canvpn
//
//  Created by Can Babaoğlu on 23.12.2022.
//

import Foundation
import CommonCrypto

struct SearchCompanyRequest: DataRequest {

    var url: String {
        let baseURL: String = "http://3.86.250.76:8181"
        let path: String = "/api/v1/vpnservers"
        return baseURL + path
    }
    
    var queryItems: [String : String] {
        [:
//            "route": apiKey,
//            "filter_text": searchText
        ]
    }
    
    var method: HTTPMethod {
        .get
    }
    
    func decode(_ data: Data) throws -> SearchCompanyItem {
        
        let hep = String(data: data, encoding: String.Encoding.utf8) as String?
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        decoder.dateDecodingStrategy = .iso8601
        /*  TODO: need fix dateDecodingStrategy
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        */
                
        let deneme = try? JSONDecoder().decode(SearchCompanyItem.self, from: data)
        
        let response = try decoder.decode(SearchCompanyItem.self, from: data)
        
        return response
    }
}
