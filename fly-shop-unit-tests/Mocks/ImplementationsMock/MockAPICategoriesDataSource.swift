//
//  MockAPICategoriesDataSource.swift
//  FlyShopUnitTests
//
//  Created by Olga Covaliova on 15.10.2025.
//

import Foundation
@testable import fly_shop

class MockAPICategoriesDataSource: APICategoriesDataSource {
    
    // MARK: - Properties
    
    var getCategoriesResult: Result<[CategoryDTO], HTTPClientError> = .success([])
    var getCategoriesCallCount: Int = 0
    
    // MARK: - APICategoriesDataSource
    
    func getCategories() async -> Result<[CategoryDTO], HTTPClientError> {
        getCategoriesCallCount += 1
        return getCategoriesResult
    }
}
