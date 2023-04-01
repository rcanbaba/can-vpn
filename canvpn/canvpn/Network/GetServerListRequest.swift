//
//  GetServerListRequest.swift
//  canvpn
//
//  Created by Can Babaoğlu on 23.12.2022.
//

import Foundation

struct GetServerListRequest: DataRequest {
    
    var url: String {
        let baseURL: String = "http://100.26.161.159"
        let path: String = "/api/servers"
        return baseURL + path
    }
    
    var queryItems: [String : String] {
        [ : ]
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var bodyData: Data?
    
    func decode(_ data: Data) throws -> ServerList {

        let response = try JSONDecoder().decode(ServerList.self, from: data)
  
        return response
    }
}
