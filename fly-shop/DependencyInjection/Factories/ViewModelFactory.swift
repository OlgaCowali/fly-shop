//
//  ViewModelFactory.swift
//  fly-shop
//
//  Created by Olga Covaliova on 18.10.2025.
//

import Foundation

// Factory responsible for creating view model implementations that handle presentation logic
final class ViewModelFactory {
    
    private let useCases: ProductListUseCases
    
    init(useCases: ProductListUseCases) {
        self.useCases = useCases
    }
    
    // MARK: - ViewModels
    
    // Creates a product list view model with all required use case dependencies
    @MainActor func makeProductListViewModel() -> ProductListViewModel {
        ProductListViewModel(
            getProductListUseCase: useCases.getProductList,
            getCategoriesUseCase: useCases.getCategories,
            getCustomerTypesUseCase: useCases.getCustomerTypes
        )
    }
}
