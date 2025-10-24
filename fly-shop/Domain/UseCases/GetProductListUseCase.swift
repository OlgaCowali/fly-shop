//
//  GetProductsUseCase.swift
//  fly-shop
//
//  Created by Olga Covaliova on 14.10.2025.
//

import Foundation

// Protocol defining the contract for retrieving a product list
protocol GetProductList {
    func execute(for customerType: CustomerType,
                 filteredBy category: Category?) async -> Result<[Product], DomainError>
}

// Use case responsible for fetching and filtering products based on customer type and category
final class GetProductListUseCase: GetProductList {
    
    private let repository: ProductListRepository
    
    init(repository: ProductListRepository) {
        self.repository = repository
    }
    
    // Retrieves products for a specific customer type, optionally filtered by category
    func execute(
        for customerType: CustomerType,
        filteredBy category: Category? = nil
    ) async -> Result<[Product], DomainError> {
        // Fetch products from repository
        let result = await repository.getProducts(for: customerType, category: category)
        
        switch result {
        case .success(let products):
            // If no category filter is specified, return all products
            guard let category = category else {
                return .success(products)
            }
            
            // Filter products by the specified category
            let filteredProducts = products.filter { $0.category == category }
            return .success(filteredProducts)
            
        case .failure(let error):
            // Pass through any repository errors
            return .failure(error)
        }
    }
}


