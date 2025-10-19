//
//  InfrastructureFactory.swift
//  fly-shop
//
//  Created by Olga Covaliova on 18.10.2025.
//

import Foundation

// Factory responsible for creating infrastructure components like HTTP clients
final class InfrastructureFactory {
    
    // MARK: - HTTP Client
    
    // Shared HTTP client instance for network operations
    private lazy var httpClient: HTTPClientProtocol = HTTPClient()
    
    // Creates and returns the HTTP client instance
    func makeHTTPClient() -> HTTPClientProtocol {
        return httpClient
    }
}
