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
    
    func execute(for customerType: fly_shop.CustomerType, filteredBy category: fly_shop.Category?) async -> Result<[fly_shop.Product], fly_shop.DomainError> {
        executeCallCount += 1
        
        if shouldReturnError {
            return .failure(.network)
        }
        
        return .success(mockProducts)
    }
}
