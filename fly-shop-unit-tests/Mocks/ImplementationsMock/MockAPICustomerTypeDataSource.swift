//
//  MockAPICustomerTypeDataSource.swift
//  FlyShopUnitTests
//
//  Created by Olga Covaliova on 16.10.2025.
//

import Foundation
@testable import fly_shop

class MockAPICustomerTypeDataSource: APICustomerTypeDataSource {
    
    // MARK: - Properties
    
    var getCustomerTypesResult: Result<[CustomerTypeDTO], HTTPClientError> = .success([])
    var getCustomerTypesCallCount = 0
    
    // MARK: - APICustomerTypeDataSource Implementation
    
    func getCustomerTypes() async -> Result<[CustomerTypeDTO], HTTPClientError> {
        getCustomerTypesCallCount += 1
        return getCustomerTypesResult
    }
}
