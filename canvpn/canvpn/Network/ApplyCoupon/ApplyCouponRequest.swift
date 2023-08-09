//
//  ApplyCouponRequest.swift
//  canvpn
//
//  Created by Can Babaoğlu on 9.08.2023.
//

import Foundation

struct ApplyCouponRequest: DataRequest {
    
    var url: String {
        let baseURL: String = Constants.baseURL
        let path: String = Endpoints.applyCoupon
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
    
    func decode(_ data: Data) throws -> ConsumeReceiptResponse {
        
        let response = try JSONDecoder().decode(ConsumeReceiptResponse.self, from: data)
        
        return response
    }
    
    mutating func setParams(code: String) {
        
        let body = ["client_params": clientParams,
                    "code": code] as [String : Any]
        
        let data = try? JSONSerialization.data(
            withJSONObject: body,
            options: []
        )
        
        bodyData = data
    }
}
