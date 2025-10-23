//
//  MockGetProductListUseCase.swift
//  fly-shop
//
//  Created by Olga Covaliova on 23.10.2025.
//

import Foundation
@testable import fly_shop

class MockGetProductListUseCase: GetProductList {
    var mockProducts: [Product] = []
    var shouldReturnError = false
    var executeCallCount = 0
    
    func execute(for customerType: CustomerType, filteredBy category: FlyShopCategory?) async -> Result<[Product], DomainError> {
        executeCallCount += 1
        
        if shouldReturnError {
            return .failure(.network)
        }
        
        return .success(mockProducts)
    }
}
