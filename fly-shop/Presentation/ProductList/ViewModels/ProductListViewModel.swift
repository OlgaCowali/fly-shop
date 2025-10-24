//
//  ProductListViewModel.swift
//  fly-shop
//
//  Created by Olga Covaliova on 17.10.2025.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class ProductListViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var displayedProducts: [Product] = []
    @Published private(set) var categories: [Category] = []
    @Published private(set) var customerTypes: [CustomerType] = []
    @Published private(set) var selectedCategory: Category?
    @Published private(set) var selectedCustomerType: CustomerType?
    @Published private(set) var selectedCurrency: Currency = .usd
    @Published private(set) var totalsByCurrency: [Currency: Decimal] = [:] // Cart totals calculated for each currency
    @ObservedObject private(set) var stateService: ProductListStateService
    
    var state: ViewState {
        stateService.state
    }
    
    // Returns the total amount for the currently selected currency
    var totalAmount: Decimal {
        totalsByCurrency[selectedCurrency] ?? 0
    }
    
    // MARK: - Dependencies
    private let getProductListUseCase: GetProductList // Use case for fetching products
    private let getCategoriesUseCase: GetCategories // Use case for fetching categories
    private let getCustomerTypesUseCase: GetCustomerTypes // Use case for fetching customer types
    private let cartService: CartSessionService // Cart session service for managing cart state
    
    private var catalogProducts: [Product] = []
    
    // MARK: - Task Management
    private var loadTask: Task<Void, Never>? // Current loading task for cancellation support
    private var cancellables = Set<AnyCancellable>() // Store Combine subscriptions
    
    // MARK: - Initialization
    init(
        getProductListUseCase: GetProductList,
        getCategoriesUseCase: GetCategories,
        getCustomerTypesUseCase: GetCustomerTypes,
        cartService: CartSessionService,
        stateManager: ProductListStateService = ProductListStateService()
    ) {
        self.getProductListUseCase = getProductListUseCase
        self.getCategoriesUseCase = getCategoriesUseCase
        self.getCustomerTypesUseCase = getCustomerTypesUseCase
        self.cartService = cartService
        self.stateService = stateManager
        
        // Observe cart service changes to sync product quantities
        setupCartServiceObservation()
    }
    
    deinit {
        loadTask?.cancel() // Cancel any ongoing loading task when view model is deallocated
    }
    
    // MARK: - Public Methods
    
    // Loads initial data including customer types, categories, and products
    func loadInitialData() async {
        cancelLoad()
        stateService.setLoading()
        
        // Load customer types and categories concurrently
        async let customerTypesResult = getCustomerTypesUseCase.execute()
        async let categoriesResult = getCategoriesUseCase.execute()
        
        // Handle results and return early if any fail
        guard handleCustomerTypesResult(await customerTypesResult) else { return }
        guard handleCategoriesResult(await categoriesResult) else { return }
        
        // Load products after successful setup
        await loadProducts()
    }
    
    // Loads products for the currently selected customer type
    func loadProducts() async {
        guard let customerType = selectedCustomerType else { return }
        stateService.setLoading()
        let result = await getProductListUseCase.execute(
            for: customerType,
            filteredBy: nil // Always load all products for the customer type
        )
        switch result {
        case .success(let products):
            // Store catalog WITHOUT quantities - they'll come from cart
            self.catalogProducts = products.map { product in
                var p = product
                p.quantity = 0 // Reset quantities - they'll come from cart
                return p
            }
            syncWithCart() // Merge with cart quantities and update display
            stateService.setLoaded()
        case .failure(let error):
            stateService.setError(error)
        }
    }
    
    // Selects a category filter and updates displayed products
    func selectCategory(_ category: Category?) {
        selectedCategory = category
        filterProducts() // Immediately apply the filter
    }
    
    // Selects a customer type and reloads products with new pricing
    func selectCustomerType(_ customerType: CustomerType) {
        selectedCustomerType = customerType
        reloadProducts() // Reload products as pricing may differ
    }
    
    // Selects a currency for price display
    func selectCurrency(_ currency: Currency) {
        selectedCurrency = currency
    }
    
     // Updates product quantity in cart
    func updateProductQuantity(_ productId: UUID, quantity: Int) {
        // Apply business rules: enforce minimum (0) and maximum (10) quantity limits
        let limitedQuantity = min(ProductListConstants.maxProductQuantity, max(0, quantity))
        
        // Find the product to update
        guard let product = catalogProducts.first(where: { $0.id == productId }) else { return }
        
        // Create updated product with new quantity
        var updatedProduct = product
        updatedProduct.quantity = limitedQuantity
        
        // Update cart service
        if limitedQuantity > 0 {
            cartService.addProduct(updatedProduct)
        } else {
            cartService.removeProduct(productId: productId)
        }
    }
    
    // MARK: - Private Methods
    
    // Handles customer types loading result and sets default if needed
    private func handleCustomerTypesResult(_ result: Result<[CustomerType], DomainError>) -> Bool {
        switch result {
        case .success(let types):
            self.customerTypes = types
            // Set default customer type if none selected
            if selectedCustomerType == nil {
                selectedCustomerType = getDefaultCustomerType(from: types)
            }
            return true
        case .failure(let error):
            stateService.setError(error)
            return false
        }
    }
    
    // Handles categories loading result
    private func handleCategoriesResult(_ result: Result<[Category], DomainError>) -> Bool {
        switch result {
        case .success(let categories):
            self.categories = categories
            return true
        case .failure(let error):
            stateService.setError(error)
            return false
        }
    }
    
    // Returns the default customer type or the first available one
    private func getDefaultCustomerType(from types: [CustomerType]) -> CustomerType? {
        types.first { $0.isDefault } ?? types.first
    }
    
    // Reloads products asynchronously with task cancellation support
    private func reloadProducts() {
        cancelLoad()
        loadTask = Task { [weak self] in
            await self?.loadProducts()
        }
    }
    
    // Cancels any ongoing loading task
    private func cancelLoad() {
        loadTask?.cancel()
        loadTask = nil
    }
    
    // Filters displayed products based on selected category and merges with cart quantities
    private func filterProducts() {
        guard let category = selectedCategory else {
            // Show all products when no category is selected
            displayedProducts = mergeWithCartQuantities(catalogProducts)
            stateService.updateState(products: displayedProducts)
            return
        }
        
        // Filter by selected category
        let filtered = catalogProducts.filter { $0.category == category }
        displayedProducts = mergeWithCartQuantities(filtered)
        stateService.updateState(products: displayedProducts)
    }
    
    // Merges catalog products with cart quantities
    private func mergeWithCartQuantities(_ products: [Product]) -> [Product] {
        let cartQuantities = Dictionary(
            uniqueKeysWithValues: cartService.selectedProducts.map { ($0.id, $0.quantity) }
        )
        
        return products.map { product in
            var p = product
            p.quantity = cartQuantities[product.id] ?? 0
            return p
        }
    }
    
    // Calculates cart totals for all supported currencies from cart service
    private func calculateTotals() {
        self.totalsByCurrency = CartCalculator.calculateTotals(for: cartService.selectedProducts, currencies: Currency.all)
    }
    
    // Sets up observation of cart service changes to sync display with cart
    private func setupCartServiceObservation() {
        // Observe changes to the cart service using the protocol publisher
        cartService.selectedProductsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                // When cart changes (from any source), refresh display
                self?.syncWithCart()
            }
            .store(in: &cancellables)
    }
    
    // Syncs displayed products and totals with cart service
    private func syncWithCart() {
        filterProducts() // Re-filter with updated quantities from cart
        calculateTotals() // Recalculate totals from cart
    }
}
