//
//  DataRequest.swift
//  canvpn
//
//  Created by Can Babaoğlu on 23.12.2022.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

protocol DataRequest {
    associatedtype Response
    
    var url: String { get }
    var method: HTTPMethod { get }
    var headers: [String : String] { get }
    var queryItems: [String : String] { get }
    var clientParams: [String: String] { get }
    
    var bodyData: Data? { get }
    
    func decode(_ data: Data) throws -> Response
}

extension DataRequest where Response: Decodable {
    func decode(_ data: Data) throws -> Response {
        let decoder = JSONDecoder()
        return try decoder.decode(Response.self, from: data)
    }
}

extension DataRequest {
    var headers: [String : String] {
        [:]
    }
    
    var queryItems: [String : String] {
        [:]
    }
    
    var clientParams: [String : String] {
        ["app": Constants.appName,
         "app_build": Constants.appBuild,
         "os_type": Constants.OSType,
         "os_version": "unknown",
         "app_language": Locale.preferredLocale().languageCode ?? "unknown",
         "installation_id": KeyValueStorage.installationId]
    }
}
