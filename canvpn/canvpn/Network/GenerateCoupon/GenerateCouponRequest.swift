//
//  GenerateCouponRequest.swift
//  canvpn
//
//  Created by Can Babaoğlu on 8.09.2023.
//

import Foundation

struct GenerateCouponRequest: DataRequest {
    
    var url: String {
        let baseURL: String = Constants.baseURL
        let path: String = Endpoints.generateCoupon
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
    
    mutating func setParams(email: String) {
        
        let body = ["client_params": clientParams,
                    "email": email] as [String : Any]
        
        let data = try? JSONSerialization.data(
            withJSONObject: body,
            options: []
        )
        
        bodyData = data
    }
}
