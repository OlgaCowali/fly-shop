//
//  HTTPClient.swift
//  fly-shop
//
//  Created by Olga Covaliova on 14.10.2025.
//
import Foundation
import Alamofire

final class HTTPClient: HTTPClientProtocol {
    func makeRequest(endpoint: Endpoint) async -> Result<Data, HTTPClientError> {
        return await withCheckedContinuation { continuation in
            AF.request(endpoint.path, interceptor: .retryPolicy)
                .validate()
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        continuation.resume(returning: .success(data))
                    case .failure(_):
                        if let status = response.response?.statusCode {
                            switch status {
                            case 400..<500: continuation.resume(returning: .failure(.clientError))
                            case 500..<600: continuation.resume(returning: .failure(.serverError))
                            default:        continuation.resume(returning: .failure(.responseError))
                            }
                        } else {
                            // No HTTP response (connectivity, timeout, etc.)
                            continuation.resume(returning: .failure(.responseError))
                        }
                    }
                }
        }
    }
}

struct Endpoint {
    let path: String
    let method: HTTPMethod
    
    init(method: HTTPMethod, path: String? = nil, queryParams: [String: Any]? = nil) {
        self.path = path ?? APIConstant.baseURLString
        self.method = method
    }
}

enum HTTPMethod {
    case get
    case post
}

