//
//  MockRepositoryFactory.swift
//  fly-shop
//
//  Created by Olga Covaliova on 18.10.2025.
//

import Foundation
@testable import fly_shop

final class MockRepositoryFactory: RepositoryFactory {
    
    var makePaymentRepositoryResult: PaymentRepository = MockPaymentRepository()
    var makePaymentRepositoryCallCount = 0
    
    init() {
        // Create mock data sources
        let mockDataSources = ProductListDataSources(
            customerType: MockAPICustomerTypeDataSource(),
            category: MockAPICategoriesDataSource(),
            product: MockAPIProductsDataSource()
        )
        
        // Create mock data source factory
        let mockDataSourceFactory = MockDataSourceFactory()
        
        super.init(dataSources: mockDataSources, dataSourceFactory: mockDataSourceFactory)
    }
    
    override func makePaymentRepository() -> PaymentRepository {
        makePaymentRepositoryCallCount += 1
        return makePaymentRepositoryResult
    }
}

// Mock implementation of PaymentRepository for testing
final class MockPaymentRepository: PaymentRepository {
    
    var processPaymentResult: Result<PaymentResponseDTO, DomainError> = .success(PaymentResponseDTO(
        status: "success",
        statusCode: 200
    ))
    var processPaymentCallCount = 0
    
    func processPayment(_ payment: Payment) async -> Result<PaymentResponseDTO, DomainError> {
        processPaymentCallCount += 1
        return processPaymentResult
    }
}
