//
//  MockCustomerTypeRepository.swift
//  fly-shop
//
//  Created by Olga Covaliova on 16.10.2025.
//
import Foundation
@testable import fly_shop

final class MockCustomerTypeRepository: CustomerTypeRepository {
    
    var getCustomerTypesResult: Result<[fly_shop.CustomerType], DomainError> = .success([])
    var getCustomerTypesCallCount = 0
    
    func getCustomerTypes() async -> Result<[fly_shop.CustomerType], fly_shop.DomainError> {
        getCustomerTypesCallCount += 1
        return getCustomerTypesResult
    }
}
