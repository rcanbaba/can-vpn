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
        
        if let subject = subject, let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            queryItems.append(URLQueryItem(name: "subject", value: encodedSubject))
        }
        
        if let body = body, let encodedBody = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            queryItems.append(URLQueryItem(name: "body", value: encodedBody))
        }
        
        components.queryItems = queryItems
        
        return components.string ?? ""
    }
}

