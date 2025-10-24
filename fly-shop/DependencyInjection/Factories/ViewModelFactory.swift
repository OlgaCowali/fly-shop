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
    private let cartService: CartSessionService
    
    init(useCases: ProductListUseCases, cartService: CartSessionService) {
        self.useCases = useCases
        self.cartService = cartService
    }
    
    // MARK: - ViewModels
    
    // Creates a product list view model with all required use case dependencies
    @MainActor func makeProductListViewModel() -> ProductListViewModel {
        ProductListViewModel(
            getProductListUseCase: useCases.getProductList,
            getCategoriesUseCase: useCases.getCategories,
            getCustomerTypesUseCase: useCases.getCustomerTypes,
            cartService: cartService
        )
    }
    
    // Creates a cart view model with all required dependencies and session service
    @MainActor func makeCartViewViewModel(selectedCurrency: Currency) -> CartViewViewModel {
        CartViewViewModel(
            selectedCurrency: selectedCurrency,
            sessionService: cartService
        )
    }
}
