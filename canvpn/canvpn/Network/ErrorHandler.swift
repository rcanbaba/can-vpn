//
//  ErrorHandler.swift
//  canvpn
//
//  Created by Can Babaoğlu on 23.12.2022.
//

import Foundation

struct ErrorHandler {
    // Change the method parameter type to [ServerError] and handle the first error
    static func resolve(with serverErrors: [ServerError]) -> ErrorResponse {
        guard let firstError = serverErrors.first else {
            return .unknownError
        }
        
        switch firstError.code {
        case 3001:
            return .couponNotFound
        case 3002:
            return .couponExpired
        case 1001:
            return .invalidEmail
        case 1003:
            return .registerFailed
        // Add all other cases here...
        default:
            return .serverError
        }
    }

    static func getErrorMessage(for error: Error) -> String {
        if let errorResponse = error as? ErrorResponse {
            return NSLocalizedString(errorResponse.localizedKey, comment: "")
        } else {
            // General error message for unexpected errors
            return NSLocalizedString("ERROR_GENERIC".localize(), comment: "A generic error message")
        }
    }
}


struct ServerError: Decodable {
    let code: Int
    let message: String
}

struct ServerErrorResponse: Decodable {
    let errors: [ServerError]
}

enum ErrorResponse: String, Error {
    case invalidEndpoint = "Invalid endpoint"
    case serverError = "Server Error"
    case couponNotFound = "COUPON_NOT_FOUND"
    case couponExpired = "COUPON_EXPIRED"
    case unknownError = "Unknown error occurred"
    case timeout = "Request timed out"
    case invalidEmail = "Invalid email"
    case registerFailed = "Register failed"
}

extension ErrorResponse {
    var localizedKey: String {
        switch self {
        case .timeout:
            return "ERROR_TIMEOUT".localize()
        case .invalidEndpoint:
            return "ERROR_INVALID_ENDPOINT".localize()
        case .serverError:
            return "ERROR_SERVER_ERROR".localize()
        case .couponNotFound:
            return "ERROR_COUPON_NOT_FOUND".localize()
        case .couponExpired:
            return "ERROR_COUPON_EXPIRED".localize()
        case .unknownError:
            return "ERROR_UNKNOWN".localize()
        case .invalidEmail:
            return "ERROR_EMAIL_INVALID".localize()
        case .registerFailed:
            return "registerFailed"
        }
    }
}
