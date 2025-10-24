//
//  CompositionRoot.swift
//  fly-shop
//
//  Created by Olga Covaliova on 17.10.2025.
//

import Foundation
import SwiftUI

// Main dependency injection container that orchestrates the creation of all app dependencies
final class CompositionRoot: ObservableObject {
    
    init() {}
    
    // Creates and returns a configured ProductListViewModel with all required dependencies
    @MainActor func makeProductListViewModel() -> ProductListViewModel {
        viewModelFactory.makeProductListViewModel()
    }
    
    // Creates and returns a configured CartViewViewModel with session service
    @MainActor func makeCartViewViewModel(selectedCurrency: Currency) -> CartViewViewModel {
        viewModelFactory.makeCartViewViewModel(
            selectedCurrency: selectedCurrency
        )
    }
    
    // Creates and returns a configured CashPaymentViewModel with payment service
    @MainActor func makeCashPaymentViewModel(
        totalAmount: Decimal,
        currency: Currency
    ) -> CashPaymentViewModel {
        viewModelFactory.makeCashPaymentViewModel(
            totalAmount: totalAmount,
            currency: currency,
            paymentService: cashPaymentService
        )
    }
    
    
    // MARK: - Services
    
    // Singleton service for managing cart session state
    @MainActor private lazy var cartSessionService: CartSessionService = CartSessionServiceImpl()
    
    // Singleton service for handling cash payments
    @MainActor private lazy var cashPaymentService: CashPaymentService = CashPaymentServiceImpl()
    
    // Container for all cart-related services
    @MainActor private lazy var cartServices: CartServices = CartServices(
        sessionService: cartSessionService,
        paymentService: cashPaymentService
    )
    
    // MARK: - Factories
    
    // Factory for creating infrastructure components (HTTP client, etc.)
    private lazy var infrastructureFactory = InfrastructureFactory()
    
    // Factory for creating data source implementations
    private lazy var dataSourceFactory = DataSourceFactory(httpClient: infrastructureFactory.makeHTTPClient())
    
    // Factory for creating repository implementations
    private lazy var repositoryFactory = RepositoryFactory(dataSources: dataSourceFactory.makeProductListDataSources())
    
    // Factory for creating use case implementations
    private lazy var useCaseFactory = UseCaseFactory(repositories: repositoryFactory.makeProductListRepositories())
    
    // Factory for creating view model implementations
    @MainActor private lazy var viewModelFactory = ViewModelFactory(useCases: useCaseFactory.makeProductListUseCases(), cartServices: cartServices)
}
