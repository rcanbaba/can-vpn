//
//  RegisterAPNSRequest.swift
//  canvpn
//
//  Created by Can Babaoğlu on 15.05.2023.
//

import Foundation

import Foundation

struct RegisterAPNSRequest: DataRequest {
    
    var url: String {
        let baseURL: String = Constants.baseURL
        let path: String = Endpoints.registerAPNS
        return baseURL + path
    }
    
    var queryItems: [String : String] {
        [ : ]
    }
    
    var headers: [String : String] {
        ["X-Device-Id": KeyValueStorage.deviceId ?? "unknown"]
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var bodyData: Data?
    
    func decode(_ data: Data) throws -> SuccessResponse {
        
        let response = try JSONDecoder().decode(SuccessResponse.self, from: data)
        
        return response
    }
    
    mutating func setParams(token: String) {
        
        let body = ["client_params": clientParams,
                    "token": token] as [String : Any]
        
        let data = try? JSONSerialization.data(
            withJSONObject: body,
            options: []
        )
        
        bodyData = data
    }
}
