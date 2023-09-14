//
//  GetIPAddressRequest.swift
//  canvpn
//
//  Created by Can Babaoğlu on 30.05.2023.
//

import Foundation

struct GetIPAddressRequest: DataRequest {
    
    var url: String {
        let baseURL: String = Constants.baseURL
        let path: String = Endpoints.getIPAddress
        return baseURL + path
    }
    
    var queryItems: [String : String] {
        [ : ]
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var bodyData: Data?
    
    func decode(_ data: Data) throws -> IPAddressResponse {
        
        let response = try JSONDecoder().decode(IPAddressResponse.self, from: data)
        
        return response
    }
}
