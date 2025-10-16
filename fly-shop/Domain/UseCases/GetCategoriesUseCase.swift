//
//  GetCategoriesUseCase.swift
//  fly-shop
//
//  Created by Olga Covaliova on 14.10.2025.
//

import Foundation

// Protocol defining the contract for retrieving categories
protocol GetCategories {
    func execute() async throws -> Result<[Category], DomainError>
}

// Use case responsible for fetching available categories
final class GetCategoriesUseCase: GetCategories {
    
    private let repository: CategoryRepository
    
    init(repository: CategoryRepository) {
        self.repository = repository
    }
    
    // Retrieves all available categories
    func execute() async throws -> Result<[Category], DomainError> {
        // Fetch categories from repository
        let result = await repository.getCategories()
        
        switch result {
        case .success(let categories):
            return .success(categories)
            
        case .failure(let error):
            // Pass through any repository errors
            return .failure(error)
        }
    }
}
