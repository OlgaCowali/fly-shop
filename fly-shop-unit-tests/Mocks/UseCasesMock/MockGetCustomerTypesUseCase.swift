//
//  MockGetCustomerTypesUseCase.swift
//  fly-shop
//
//  Created by Olga Covaliova on 23.10.2025.
//

import Foundation
@testable import fly_shop

class MockGetCustomerTypesUseCase: GetCustomerTypes {
    var mockCustomerTypes: [CustomerType] = []
    var shouldReturnError = false
    
    func execute() async -> Result<[CustomerType], DomainError> {
        if shouldReturnError {
            return .failure(.network)
        }
        
        return .success(mockCustomerTypes)
    }
}
