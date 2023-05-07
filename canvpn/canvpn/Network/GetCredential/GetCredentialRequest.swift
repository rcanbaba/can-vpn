//
//  GetCredentialRequest.swift
//  canvpn
//
//  Created by Can Babaoğlu on 1.04.2023.
//

import Foundation

struct GetCredentialRequest: DataRequest {
    
    var url: String {
        let baseURL: String = Constants.baseURL
        let path: String = Endpoints.getCredential
        return baseURL + path
    }
    
    var queryItems: [String : String] {
        [ : ]
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var bodyData: Data?
    
    func decode(_ data: Data) throws -> Credential {
        
        let response = try JSONDecoder().decode(Credential.self, from: data)
        
        return response
    }
    
    mutating func setParams(serverId: String) {
        let body = ["server_id": serverId]
        
        let data = try? JSONSerialization.data(
            withJSONObject: body,
            options: []
        )
        
        bodyData = data
    }
}
