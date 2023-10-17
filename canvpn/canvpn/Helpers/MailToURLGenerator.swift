//
//  MailToURLGenerator.swift
//  canvpn
//
//  Created by Can Babaoğlu on 17.10.2023.
//

import Foundation

struct MailToURLGenerator {
    
    static func generateMailToURL(email: String, subject: String? = nil, body: String? = nil) -> String {
        var components = URLComponents()
        components.scheme = "mailto"
        components.path = email
        
        var queryItems: [URLQueryItem] = []
        
        if let subject = subject {
            queryItems.append(URLQueryItem(name: "subject", value: subject))
        }
        
        if let body = body {
            queryItems.append(URLQueryItem(name: "body", value: body))
        }
        
        components.queryItems = queryItems
        
        return components.string ?? ""
    }
}

