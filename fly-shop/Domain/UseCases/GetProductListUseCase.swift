//
//  GetProductsUseCase.swift
//  fly-shop
//
//  Created by Olga Covaliova on 14.10.2025.
//

import Foundation

protocol GetProductList {
    func execute(for customerType: CustomerType,
                 filteredBy category: Category?) async throws -> [Product]
}

final class GetProductListUseCase: GetProductList {
    
    private let repository: ProductListRepository
    
    init(repository: ProductListRepository) {
        self.repository = repository
    }
    
    func execute(
        for customerType: CustomerType,
        filteredBy category: Category? = nil
    ) async throws -> [Product] {
        let products = try await repository.getProducts(for: customerType)
        
        guard let category = category else {
            return products
        }
        
        return products.filter { $0.category == category }
    }
}

