//
//  MockGetCategoriesUseCase.swift
//  fly-shop
//
//  Created by Olga Covaliova on 23.10.2025.
//

import Foundation
@testable import fly_shop

class MockGetCategoriesUseCase: GetCategories {
    var mockCategories: [fly_shop.Category] = []
    var shouldReturnError = false
    
    func execute() async -> Result<[fly_shop.Category], DomainError> {
        if shouldReturnError {
            return .failure(.network)
        }
        
        return .success(mockCategories)
    }
}
