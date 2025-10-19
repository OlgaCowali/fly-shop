//
//  RepositoryFactory.swift
//  fly-shop
//
//  Created by Olga Covaliova on 18.10.2025.
//

import Foundation

// Factory responsible for creating repository implementations that bridge domain and data layers
final class RepositoryFactory {
    
    private let dataSources: ProductListDataSources
    
    init(dataSources: ProductListDataSources) {
        self.dataSources = dataSources
    }
    
    // Creates a customer type repository implementation
    func makeCustomerTypeRepository() -> CustomerTypeRepository {
        CustomerTypeRepositoryImpl(apiDataSource: dataSources.customerType)
    }
    
    // Creates a category repository implementation
    func makeCategoryRepository() -> CategoryRepository {
        CategoryRepositoryImpl(apiDataSource: dataSources.category)
    }
    
    // Creates a product list repository implementation
    func makeProductListRepository() -> ProductListRepository {
        ProductListRepositoryImpl(apiDataSource: dataSources.product)
    }
    
    // Creates a container with all repositories needed for the product list feature
    func makeProductListRepositories() -> ProductListRepositories {
        ProductListRepositories(
            customerType: makeCustomerTypeRepository(),
            category: makeCategoryRepository(),
            product: makeProductListRepository()
        )
    }
}
