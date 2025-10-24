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
    private let cartServices: CartServices
    
    init(useCases: ProductListUseCases, cartServices: CartServices) {
        self.useCases = useCases
        self.cartServices = cartServices
    }
    
    // MARK: - ViewModels
    
    // Creates a product list view model with all required use case dependencies
    @MainActor func makeProductListViewModel() -> ProductListViewModel {
        ProductListViewModel(
            getProductListUseCase: useCases.getProductList,
            getCategoriesUseCase: useCases.getCategories,
            getCustomerTypesUseCase: useCases.getCustomerTypes,
            cartService: cartServices.sessionService
        )
    }
    
    // Creates a cart view model with all required dependencies and session service
    @MainActor func makeCartViewViewModel(selectedCurrency: Currency) -> CartViewViewModel {
        CartViewViewModel(
            selectedCurrency: selectedCurrency,
            sessionService: cartServices.sessionService,
            paymentService: cartServices.paymentService
        )
    }
    
    // Creates a cash payment view model with payment service and payment details
    @MainActor func makeCashPaymentViewModel(
        totalAmount: Decimal,
        currency: Currency,
        paymentService: CashPaymentService
    ) -> CashPaymentViewModel {
        CashPaymentViewModel(
            paymentService: paymentService,
            totalAmount: totalAmount,
            currency: currency
        )
    }
    
}
