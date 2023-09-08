//
//  NetworkService.swift
//  canvpn
//
//  Created by Can Babaoğlu on 23.12.2022.
//

import Foundation

protocol NetworkService {
    func request<Request: DataRequest>(_ request: Request, completion: @escaping (Result<Request.Response, Error>) -> Void)
}

final class DefaultNetworkService: NetworkService {
    
    func request<Request: DataRequest>(_ request: Request, completion: @escaping (Result<Request.Response, Error>) -> Void) {
        guard let urlRequest = prepareURLRequest(from: request) else {
            return completion(.failure(ErrorResponse.invalidEndpoint))
        }
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                if let urlError = error as? URLError, urlError.code == .timedOut {
                    return completion(.failure(ErrorResponse.timeout))
                }
                return completion(.failure(error))
            }
            
            guard let response = response as? HTTPURLResponse else {
                return completion(.failure(ErrorResponse.serverError))
            }
            
            if 200..<300 ~= response.statusCode {
                guard let data = data else {
                    return completion(.failure(ErrorResponse.serverError))
                }
                
                if response.statusCode == 204 {
                    return completion(.success(SuccessResponse(success: true) as! Request.Response))
                }
                
                do {
                    try completion(.success(request.decode(data)))
                } catch let decodingError as DecodingError {
                    switch decodingError {
                    case .typeMismatch(let type, let context):
                        print("Decode 1995 - Type mismatch: \(type), context: \(context)")
                    case .valueNotFound(let type, let context):
                        print("Decode 1995 - Value not found: \(type), context: \(context)")
                    case .keyNotFound(let key, let context):
                        print("Decode 1995 - Key not found: \(key), context: \(context)")
                    case .dataCorrupted(let context):
                        print("Decode 1995 - Data corrupted: \(context)")
                    @unknown default:
                        print("Decode 1995 - Unknown decoding error: \(decodingError)")
                    }
                    completion(.failure(decodingError))
                } catch {
                    print("Decode 1995 - Unexpected error: \(error)")
                    completion(.failure(error))
                }
                
            } else {
                if let data = data, let serverErrorsResponse = try? JSONDecoder().decode(ServerErrorResponse.self, from: data) {
                    let resolvedError = ErrorHandler.resolve(with: serverErrorsResponse.errors)
                    completion(.failure(resolvedError))
                } else {
                    completion(.failure(ErrorResponse.unknownError))
                }
            }
        }
        .resume()
    }
    
    private func prepareURLRequest<Request: DataRequest>(from request: Request) -> URLRequest? {
        guard var urlComponent = URLComponents(string: request.url) else {
            return nil
        }
        
        let queryItems = request.queryItems.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        
        urlComponent.queryItems = queryItems
        
        guard let url = urlComponent.url else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.bodyData
        urlRequest.allHTTPHeaderFields = request.headers
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        urlRequest.timeoutInterval = Constants.requestTimeout
        
        return urlRequest
    }
}
