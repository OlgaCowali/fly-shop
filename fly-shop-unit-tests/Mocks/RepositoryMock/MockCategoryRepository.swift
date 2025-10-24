//
//  MockCategoryRepository.swift
//  fly-shop
//
//  Created by Olga Covaliova on 16.10.2025.
//
import Foundation
@testable import fly_shop

final class MockCategoryRepository: CategoryRepository {
    
    var getCategoriesResult: Result<[fly_shop.Category], DomainError> = .success([])
    var getCategoriesCallCount = 0
    func getCategories() async -> Result<[fly_shop.Category], fly_shop.DomainError> {
        getCategoriesCallCount += 1
        return getCategoriesResult
    }
}
