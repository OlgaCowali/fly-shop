//
//  MockHTTPClient.swift
//  FlyShopUnitTests
//
//  Created by Olga Covaliova on 16.10.2025.
//

import Foundation
@testable import fly_shop

class MockHTTPClient: HTTPClientProtocol {
    
    // MARK: - Properties
    
    var makeRequestResult: Result<Data, HTTPClientError> = .failure(.generic)
    var makeRequestCallCount = 0
    var lastEndpoint: Endpoint?
    
    // MARK: - HTTPClientProtocol Implementation
    
    func makeRequest(endpoint: Endpoint) async -> Result<Data, HTTPClientError> {
        makeRequestCallCount += 1
        lastEndpoint = endpoint
        return makeRequestResult
    }
    
    // MARK: - Test Helpers
    
    func setSuccessResult(data: Data) {
        makeRequestResult = .success(data)
    }
    
    func setFailureResult(error: HTTPClientError) {
        makeRequestResult = .failure(error)
    }
}
