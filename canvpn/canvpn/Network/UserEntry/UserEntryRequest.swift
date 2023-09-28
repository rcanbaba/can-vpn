//
//  UserEntryRequest.swift
//  canvpn
//
//  Created by Can Babaoğlu on 28.09.2023.
//

import Foundation

struct UserEntryRequest: DataRequest {
    
    var url: String {
        let baseURL: String = Constants.baseURL
        let path: String = Endpoints.userEntry
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
    
    mutating func setClientParams() {
        let body = ["client_params" : clientParams]
        
        let data = try? JSONSerialization.data(
            withJSONObject: body,
            options: []
        )
        
        bodyData = data
    }
}
