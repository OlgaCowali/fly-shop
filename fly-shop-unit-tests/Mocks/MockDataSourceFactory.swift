//
//  MockDataSourceFactory.swift
//  FlyShopUnitTests
//
//  Created by Olga Covaliova on 18.10.2025.
//

import Foundation
@testable import fly_shop

final class MockDataSourceFactory: DataSourceFactoryProtocol {
    
    var makePaymentDataSourceResult: APIPaymentDataSource = MockAPIPaymentDataSource()
    var makePaymentDataSourceCallCount = 0
    
    init() {
        // Mock factory doesn't need HTTP client
    }
    
    func makePaymentDataSource() -> APIPaymentDataSource {
        makePaymentDataSourceCallCount += 1
        return makePaymentDataSourceResult
    }
}

// Mock implementation of APIPaymentDataSource for testing
final class MockAPIPaymentDataSource: APIPaymentDataSource {
    
    var processPaymentResult: Result<PaymentResponseDTO, HTTPClientError> = .success(PaymentResponseDTO(
        status: "success",
        statusCode: 200
    ))
    var processPaymentCallCount = 0
    
    func processPayment(request: PaymentRequestDTO) async -> Result<PaymentResponseDTO, HTTPClientError> {
        processPaymentCallCount += 1
        return processPaymentResult
    }
}
