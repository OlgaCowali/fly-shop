//
//  GetCustomerTypesUseCase.swift
//  fly-shop
//
//  Created by Olga Covaliova on 14.10.2025.
//

import Foundation

// Protocol defining the contract for retrieving customer types
protocol GetCustomerTypes {
    func execute() async throws -> Result<[CustomerType], DomainError>
}

// Use case responsible for fetching available customer types
final class GetCustomerTypesUseCase: GetCustomerTypes {
    
    private let repository: CustomerTypeRepository
    
    init(repository: CustomerTypeRepository) {
        self.repository = repository
    }
    
    // Retrieves all available customer types
    func execute() async throws -> Result<[CustomerType], DomainError> {
        // Fetch customer types from repository
        let result = await repository.getCustomerTypes()
        
        switch result {
        case .success(let customerTypes):
            return .success(customerTypes)
            
        case .failure(let error):
            // Pass through any repository errors
            return .failure(error)
        }
    }
}
