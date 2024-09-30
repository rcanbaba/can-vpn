//
//  FetchSettingsRequest.swift
//  canvpn
//
//  Created by Can Babaoğlu on 7.05.2023.
//

import Foundation

struct FetchSettingsRequest: DataRequest {
    
    var url: String {
        let baseURL: String = Constants.baseURL
        let path: String = Endpoints.fetchSettings
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
    
    func decode(_ data: Data) throws -> Settings {
        
#if DEBUG
        // Convert Data to String to inspect the raw JSON
        if let jsonString = String(data: data, encoding: .utf8) {
            print("Raw JSON data: \(jsonString)")
        } else {
            print("Unable to convert data to String")
        }
#endif
        
        let response = try JSONDecoder().decode(Settings.self, from: data)
        
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
    
    mutating func setClientParams(languageCode: String) {
        var body = ["client_params" : clientParams]
        
        if var clientParamsDict = body["client_params"] {
            clientParamsDict["app_language"] = languageCode
            body["client_params"] = clientParamsDict
        }
        
        let data = try? JSONSerialization.data(
            withJSONObject: body,
            options: []
        )
        
        bodyData = data
    }

}
