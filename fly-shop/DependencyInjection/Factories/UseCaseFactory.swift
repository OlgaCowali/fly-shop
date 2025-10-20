//
//  UseCaseFactory.swift
//  fly-shop
//
//  Created by Olga Covaliova on 18.10.2025.
//

import Foundation

// Factory responsible for creating use case implementations that contain business logic
final class UseCaseFactory {
    
    private let repositories: ProductListRepositories
    
    init(repositories: ProductListRepositories) {
        self.repositories = repositories
    }
    
    // Creates a container with all use cases needed for the product list feature
     func makeProductListUseCases() -> ProductListUseCases {
        ProductListUseCases(
            getCustomerTypes: makeGetCustomerTypesUseCase(),
            getCategories: makeGetCategoriesUseCase(),
            getProductList: makeGetProductListUseCase()
        )
    }
    
    // Creates a use case for retrieving customer types
    private func makeGetCustomerTypesUseCase() -> GetCustomerTypes {
        GetCustomerTypesUseCase(repository: repositories.customerType)
    }
    
    // Creates a use case for retrieving categories
    private func makeGetCategoriesUseCase() -> GetCategories {
        GetCategoriesUseCase(repository: repositories.category)
    }
    
    // Creates a use case for retrieving product list
    private func makeGetProductListUseCase() -> GetProductList {
        GetProductListUseCase(repository: repositories.product)
    }
}
