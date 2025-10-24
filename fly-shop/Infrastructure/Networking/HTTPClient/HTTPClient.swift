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
            // Configure the request based on the HTTP method
            var request: DataRequest
            
            switch endpoint.method {
            case .get:
                request = AF.request(endpoint.path, interceptor: .retryPolicy)
            case .post:
                var urlRequest = URLRequest(url: URL(string: endpoint.path)!)
                urlRequest.httpMethod = "POST"
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                if let body = endpoint.body {
                    urlRequest.httpBody = body
                }
                
                request = AF.request(urlRequest, interceptor: .retryPolicy)
            }
            
            request
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
    let body: Data?
    
    init(method: HTTPMethod, path: String? = nil, queryParams: [String: Any]? = nil, body: Data? = nil) {
        self.path = path ?? APIConstant.baseURLString
        self.method = method
        self.body = body
    }
}

enum HTTPMethod {
    case get
    case post
}

