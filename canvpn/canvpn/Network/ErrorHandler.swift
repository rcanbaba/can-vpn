//
//  ErrorHandler.swift
//  canvpn
//
//  Created by Can Babaoğlu on 23.12.2022.
//

import Foundation

struct ErrorHandler {
    static func resolve(with serverError: ServerError) -> ErrorResponse {
        switch serverError.code {
        case 3001:
            return .couponNotFound
        case 3002:
            return .couponExpired
        // Add all other cases here...
        default:
            return .serverError
        }
    }
}

struct ServerError: Decodable {
    let code: Int
    let message: String
}

enum ErrorResponse: String, Error {
    case invalidEndpoint = "Invalid endpoint"
    case serverError = "Server Error"
    case couponNotFound = "COUPON_NOT_FOUND"
    case couponExpired = "COUPON_EXPIRED"
    case unknownError = "Unknown error occurred"
}

extension ErrorResponse {
    var localizedKey: String {
        switch self {
        case .invalidEndpoint:
            return "ERROR_INVALID_ENDPOINT"
        case .serverError:
            return "ERROR_SERVER_ERROR"
        case .couponNotFound:
            return "ERROR_COUPON_NOT_FOUND"
        case .couponExpired:
            return "ERROR_COUPON_EXPIRED"
        case .unknownError:
            return "ERROR_UNKNOWN"
        }
    }
}
