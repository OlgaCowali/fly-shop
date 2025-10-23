//
//  MockGetCategoriesUseCase.swift
//  fly-shop
//
//  Created by Olga Covaliova on 23.10.2025.
//

import Foundation
@testable import fly_shop

class MockGetCategoriesUseCase: GetCategories {
    var mockCategories: [FlyShopCategory] = []
    var shouldReturnError = false
    
    func execute() async -> Result<[FlyShopCategory], DomainError> {
        if shouldReturnError {
            return .failure(.network)
        }
        
        return .success(mockCategories)
    }
}
