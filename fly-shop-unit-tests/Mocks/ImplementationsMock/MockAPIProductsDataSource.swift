//
//  MockAPIProductsDataSource.swift
//  FlyShopUnitTests
//
//  Created by Olga Covaliova on 16.10.2025.
//

import Foundation
@testable import fly_shop

final class MockAPIProductsDataSource: APIProductsDataSource {
    
    var getProductsResult: Result<[ProductDTO], HTTPClientError> = .success([])
    var getProductsCallCount = 0
    var lastCustomerType: CustomerType?
    var lastCategory: fly_shop.Category?
    
    func getProducts(for customerType: CustomerType, category: fly_shop.Category?) async -> Result<[ProductDTO], HTTPClientError> {
        getProductsCallCount += 1
        lastCustomerType = customerType
        lastCategory = category
        return getProductsResult
    }
}
