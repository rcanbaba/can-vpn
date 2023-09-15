//
//  ConsumeReceiptRequest.swift
//  canvpn
//
//  Created by Can Babaoğlu on 26.06.2023.
//

import Foundation

struct ConsumeReceiptRequest: DataRequest {
    
    var url: String {
        let baseURL: String = Constants.baseURL
        let path: String = Endpoints.consumeReceipt
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
    
    mutating func setParams(receipt: String, code: String? = nil) {
        
        var body: [String : Any]
        
        if let code = code {
            body = ["client_params": clientParams,
                    "receipt": receipt,
                    "coupon_code": code] as [String : Any]
        } else {
            body = ["client_params": clientParams,
                    "receipt": receipt] as [String : Any]
        }
        
        let data = try? JSONSerialization.data(
            withJSONObject: body,
            options: []
        )
        
        bodyData = data
    }
}
