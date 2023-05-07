//
//  RegisterDeviceRequest.swift
//  canvpn
//
//  Created by Can Babaoğlu on 7.05.2023.
//

import Foundation

struct RegisterDeviceRequest: DataRequest {
    
    var url: String {
        let baseURL: String = Constants.baseURL
        let path: String = Endpoints.registerDevice
        return baseURL + path
    }
    
    var queryItems: [String : String] {
        [ : ]
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var bodyData: Data?
    
    func decode(_ data: Data) throws -> RegisterResponse {
        
        let response = try JSONDecoder().decode(RegisterResponse.self, from: data)
        
        return response
    }
    
    mutating func setRegisterParams() {
        let body = clientParams
        
        let data = try? JSONSerialization.data(
            withJSONObject: body,
            options: []
        )
        
        bodyData = data
    }
}
