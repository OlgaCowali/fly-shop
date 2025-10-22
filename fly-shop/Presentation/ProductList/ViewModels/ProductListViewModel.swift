//
//  ProductListViewModel.swift
//  fly-shop
//
//  Created by Olga Covaliova on 17.10.2025.
//

import Foundation
import SwiftUI

@MainActor
final class ProductListViewModel: ObservableObject {
    // MARK: - View State
    enum ViewState: Equatable {
        case loading
        case loaded
        case error(DomainError)
    }
    // MARK: - Published Properties
    @Published var displayedProducts: [Product] = []
    @Published private(set) var categories: [Category] = []
    @Published private(set) var customerTypes: [CustomerType] = []
    @Published private(set) var selectedCategory: Category?
    @Published private(set) var selectedCustomerType: CustomerType?
    @Published private(set) var selectedCurrency: Currency = .usd
    @Published private(set) var state: ViewState = .loading
    @Published private(set) var totalsByCurrency: [Currency: Decimal] = [:] // Cart totals calculated for each currency
    
    // Returns the total amount for the currently selected currency
    var totalAmount: Decimal {
        totalsByCurrency[selectedCurrency] ?? 0
    }
    
    // MARK: - Dependencies
    private let getProductListUseCase: GetProductList // Use case for fetching products
    private let getCategoriesUseCase: GetCategories // Use case for fetching categories
    private let getCustomerTypesUseCase: GetCustomerTypes // Use case for fetching customer types
    
    private var storedProducts: [Product] = [] // Store all products with their quantities (unfiltered)
    
    // MARK: - Task Management
    private var loadTask: Task<Void, Never>? // Current loading task for cancellation support
    
    // MARK: - Initialization
    init(
        getProductListUseCase: GetProductList,
        getCategoriesUseCase: GetCategories,
        getCustomerTypesUseCase: GetCustomerTypes
    ) {
        self.getProductListUseCase = getProductListUseCase
        self.getCategoriesUseCase = getCategoriesUseCase
        self.getCustomerTypesUseCase = getCustomerTypesUseCase
    }
    
    deinit {
        loadTask?.cancel() // Cancel any ongoing loading task when view model is deallocated
    }
    
    // MARK: - Public Methods
    
    // Loads initial data including customer types, categories, and products
    func loadInitialData() async {
        cancelLoad()
        state = .loading
        
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
        state = .loading
        let result = await getProductListUseCase.execute(
            for: customerType,
            filteredBy: nil // Always load all products for the customer type
        )
        switch result {
        case .success(let products):
            self.storedProducts = products
            filterProducts() // Apply current category filter
            calculateTotals() // Recalculate cart totals
            self.state = .loaded
        case .failure(let error):
            self.state = .error(error)
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
    
    // Updates product quantity in cart and recalculates totals
    func updateProductQuantity(_ productId: UUID, quantity: Int) {
        // Apply business rules: enforce minimum (0) and maximum (10) quantity limits
        let limitedQuantity = min(ProductListConstants.maxProductQuantity, max(0, quantity))
        
        // Update in both stored and displayed products using CartCalculator
        if CartCalculator.updateProductQuantityInBothArrays(
            storedProducts: &storedProducts,
            displayedProducts: &displayedProducts,
            productId: productId,
            quantity: limitedQuantity
        ) {
            // Recalculate totals after quantity change
            calculateTotals()
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
            self.state = .error(error)
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
            self.state = .error(error)
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
    
    // Filters displayed products based on selected category
    private func filterProducts() {
        guard let category = selectedCategory else {
            // Show all products when no category is selected
            displayedProducts = storedProducts
            return
        }
        
        // Filter by selected category
        displayedProducts = storedProducts.filter { $0.category == category }
    }
    
    // Calculates cart totals for all supported currencies
    private func calculateTotals() {
        self.totalsByCurrency = CartCalculator.calculateTotals(for: storedProducts, currencies: Currency.all)
    }
}
