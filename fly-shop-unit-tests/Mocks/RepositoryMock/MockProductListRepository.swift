//
//  MockProductListRepository.swift
//  fly-shop
//
//  Created by Olga Covaliova on 16.10.2025.
//
import Foundation
@testable import fly_shop

final class MockProductListRepository: ProductListRepository {
    
    var getProductsResult: Result<[fly_shop.Product], DomainError> = .success([])
    var getProductsCallCount = 0
    var lastCustomerType: CustomerType?
    var lastCategory: fly_shop.Category?
    
    func getProducts(for customerType: CustomerType, category: fly_shop.Category?) async -> Result<[fly_shop.Product], fly_shop.DomainError> {
        getProductsCallCount += 1
        lastCustomerType = customerType
        lastCategory = category
        return getProductsResult
    }
}
