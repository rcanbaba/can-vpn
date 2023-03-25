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
        let baseURL: String = "http://100.26.161.159"
        let path: String = "/api/servers"
        return baseURL + path
    }
    
    var queryItems: [String : String] {
        [:
//            "route": apiKey,
//            "filter_text": searchText
        ]
    }
    
    var method: HTTPMethod {
        .post
    }
    
    func decode(_ data: Data) throws -> ServerList {
        /*
        let hep = String(data: data, encoding: String.Encoding.utf8) as String?
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        decoder.dateDecodingStrategy = .iso8601
        
        let response = try decoder.decode(ServerList.self, from: data)
        */
        /*  TODO: need fix dateDecodingStrategy
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        */
                
        let response = try JSONDecoder().decode(ServerList.self, from: data)
  
        return response
    }
}
