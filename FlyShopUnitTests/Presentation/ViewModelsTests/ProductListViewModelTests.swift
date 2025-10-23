//
//  ProductListViewModelTests.swift
//  fly-shop
//
//  Created by Olga Covaliova on 23.10.2025.
//

import Testing
import Foundation
@testable import fly_shop

// Use fully qualified names to avoid ambiguity with Objective-C runtime
typealias FlyShopCategory = fly_shop.Category

@MainActor
struct ProductListViewModelTests {
    
    // MARK: - Test Data
    
    private let testCategory1 = FlyShopCategory(name: "Flies", key: "flies")
    private let testCategory2 = FlyShopCategory(name: "Rods", key: "rods")
    private let testCustomerType1 = CustomerType(key: "retail", name: "Retail", isDefault: true)
    private let testCustomerType2 = CustomerType(key: "wholesale", name: "Wholesale", isDefault: false)
    
    private var testProducts: [Product] {
        [
            Product(
                name: "Dry Fly",
                prices: [.usd: 10.99, .eur: 9.99, .gbp: 8.99],
                imageURL: "dry-fly.jpg",
                category: testCategory1,
                quantity: 0,
                customerType: testCustomerType1
            ),
            Product(
                name: "Wet Fly",
                prices: [.usd: 12.99, .eur: 11.99, .gbp: 10.99],
                imageURL: "wet-fly.jpg",
                category: testCategory1,
                quantity: 0,
                customerType: testCustomerType1
            ),
            Product(
                name: "Fly Rod",
                prices: [.usd: 299.99, .eur: 279.99, .gbp: 249.99],
                imageURL: "fly-rod.jpg",
                category: testCategory2,
                quantity: 0,
                customerType: testCustomerType1
            )
        ]
    }
    
    // MARK: - Initialization Tests
    
    @Test("Initialization sets correct initial state")
    func testInitialization() async {
        let mockGetProductList = MockGetProductListUseCase()
        let mockGetCategories = MockGetCategoriesUseCase()
        let mockGetCustomerTypes = MockGetCustomerTypesUseCase()
        
        let viewModel = ProductListViewModel(
            getProductListUseCase: mockGetProductList,
            getCategoriesUseCase: mockGetCategories,
            getCustomerTypesUseCase: mockGetCustomerTypes
        )
        
        #expect(viewModel.state == ProductListViewModel.ViewState.loading)
        #expect(viewModel.displayedProducts.isEmpty)
        #expect(viewModel.categories.isEmpty)
        #expect(viewModel.customerTypes.isEmpty)
        #expect(viewModel.selectedCategory == nil)
        #expect(viewModel.selectedCustomerType == nil)
        #expect(viewModel.selectedCurrency == Currency.usd)
        #expect(viewModel.totalAmount == 0)
    }
    
    // MARK: - Loading State Tests
    
    @Test("State changes to loading when loadInitialData is called")
    func testLoadInitialDataSetsLoadingState() async {
        let mockGetProductList = MockGetProductListUseCase()
        let mockGetCategories = MockGetCategoriesUseCase()
        let mockGetCustomerTypes = MockGetCustomerTypesUseCase()
        
        let viewModel = ProductListViewModel(
            getProductListUseCase: mockGetProductList,
            getCategoriesUseCase: mockGetCategories,
            getCustomerTypesUseCase: mockGetCustomerTypes
        )
        
        await viewModel.loadInitialData()
        
        #expect(viewModel.state == ProductListViewModel.ViewState.loading)
    }
    
    @Test("State changes to error when customer types loading fails")
    func testCustomerTypesErrorHandling() async {
        let mockGetProductList = MockGetProductListUseCase()
        let mockGetCategories = MockGetCategoriesUseCase()
        let mockGetCustomerTypes = MockGetCustomerTypesUseCase()
        mockGetCustomerTypes.shouldReturnError = true
        
        let viewModel = ProductListViewModel(
            getProductListUseCase: mockGetProductList,
            getCategoriesUseCase: mockGetCategories,
            getCustomerTypesUseCase: mockGetCustomerTypes
        )
        
        await viewModel.loadInitialData()
        
        if case ProductListViewModel.ViewState.error(let error) = viewModel.state {
            #expect(error == DomainError.network)
        } else {
            Issue.record("Expected error state")
        }
    }
    
    @Test("State changes to error when categories loading fails")
    func testCategoriesErrorHandling() async {
        let mockGetProductList = MockGetProductListUseCase()
        let mockGetCategories = MockGetCategoriesUseCase()
        mockGetCategories.shouldReturnError = true
        let mockGetCustomerTypes = MockGetCustomerTypesUseCase()
        
        let viewModel = ProductListViewModel(
            getProductListUseCase: mockGetProductList,
            getCategoriesUseCase: mockGetCategories,
            getCustomerTypesUseCase: mockGetCustomerTypes
        )
        
        await viewModel.loadInitialData()
        
        if case ProductListViewModel.ViewState.error(let error) = viewModel.state {
            #expect(error == DomainError.network)
        } else {
            Issue.record("Expected error state")
        }
    }
    
    // MARK: - Data Loading Tests
    
    @Test("Loads customer types and sets default")
    func testLoadsCustomerTypesAndSetsDefault() async {
        let mockGetProductList = MockGetProductListUseCase()
        let mockGetCategories = MockGetCategoriesUseCase()
        let mockGetCustomerTypes = MockGetCustomerTypesUseCase()
        mockGetCustomerTypes.mockCustomerTypes = [testCustomerType1, testCustomerType2]
        
        let viewModel = ProductListViewModel(
            getProductListUseCase: mockGetProductList,
            getCategoriesUseCase: mockGetCategories,
            getCustomerTypesUseCase: mockGetCustomerTypes
        )
        
        await viewModel.loadInitialData()
        
        #expect(viewModel.customerTypes.count == 2)
        #expect(viewModel.selectedCustomerType == testCustomerType1) // Default customer type
    }
    
    @Test("Loads categories successfully")
    func testLoadsCategories() async {
        let mockGetProductList = MockGetProductListUseCase()
        let mockGetCategories = MockGetCategoriesUseCase()
        mockGetCategories.mockCategories = [testCategory1, testCategory2]
        let mockGetCustomerTypes = MockGetCustomerTypesUseCase()
        mockGetCustomerTypes.mockCustomerTypes = [testCustomerType1]
        
        let viewModel = ProductListViewModel(
            getProductListUseCase: mockGetProductList,
            getCategoriesUseCase: mockGetCategories,
            getCustomerTypesUseCase: mockGetCustomerTypes
        )
        
        await viewModel.loadInitialData()
        
        #expect(viewModel.categories.count == 2)
        #expect(viewModel.categories.contains(testCategory1))
        #expect(viewModel.categories.contains(testCategory2))
    }
    
    @Test("Loads products successfully")
    func testLoadsProducts() async {
        let mockGetProductList = MockGetProductListUseCase()
        mockGetProductList.mockProducts = testProducts
        let mockGetCategories = MockGetCategoriesUseCase()
        let mockGetCustomerTypes = MockGetCustomerTypesUseCase()
        mockGetCustomerTypes.mockCustomerTypes = [testCustomerType1]
        
        let viewModel = ProductListViewModel(
            getProductListUseCase: mockGetProductList,
            getCategoriesUseCase: mockGetCategories,
            getCustomerTypesUseCase: mockGetCustomerTypes
        )
        
        await viewModel.loadInitialData()
        
        #expect(viewModel.displayedProducts.count == 3)
        #expect(viewModel.state == ProductListViewModel.ViewState.loaded)
    }
    
    // MARK: - Filtering Tests
    
    @Test("Filters products by selected category")
    func testFiltersProductsByCategory() async {
        let mockGetProductList = MockGetProductListUseCase()
        mockGetProductList.mockProducts = testProducts
        let mockGetCategories = MockGetCategoriesUseCase()
        mockGetCategories.mockCategories = [testCategory1, testCategory2]
        let mockGetCustomerTypes = MockGetCustomerTypesUseCase()
        mockGetCustomerTypes.mockCustomerTypes = [testCustomerType1]
        
        let viewModel = ProductListViewModel(
            getProductListUseCase: mockGetProductList,
            getCategoriesUseCase: mockGetCategories,
            getCustomerTypesUseCase: mockGetCustomerTypes
        )
        
        await viewModel.loadInitialData()
        
        // Initially shows all products
        #expect(viewModel.displayedProducts.count == 3)
        
        // Filter by category
        viewModel.selectCategory(testCategory1)
        
        #expect(viewModel.displayedProducts.count == 2)
        #expect(viewModel.displayedProducts.allSatisfy { $0.category == testCategory1 })
    }
    
    @Test("Shows all products when no category is selected")
    func testShowsAllProductsWhenNoCategorySelected() async {
        let mockGetProductList = MockGetProductListUseCase()
        mockGetProductList.mockProducts = testProducts
        let mockGetCategories = MockGetCategoriesUseCase()
        let mockGetCustomerTypes = MockGetCustomerTypesUseCase()
        mockGetCustomerTypes.mockCustomerTypes = [testCustomerType1]
        
        let viewModel = ProductListViewModel(
            getProductListUseCase: mockGetProductList,
            getCategoriesUseCase: mockGetCategories,
            getCustomerTypesUseCase: mockGetCustomerTypes
        )
        
        await viewModel.loadInitialData()
        
        // Clear category selection
        viewModel.selectCategory(nil)
        
        #expect(viewModel.displayedProducts.count == 3)
        #expect(viewModel.selectedCategory == nil)
    }
    
    // MARK: - Customer Type Selection Tests
    
    @Test("Selects customer type and reloads products")
    func testSelectsCustomerTypeAndReloadsProducts() async {
        let mockGetProductList = MockGetProductListUseCase()
        mockGetProductList.mockProducts = testProducts
        let mockGetCategories = MockGetCategoriesUseCase()
        let mockGetCustomerTypes = MockGetCustomerTypesUseCase()
        mockGetCustomerTypes.mockCustomerTypes = [testCustomerType1, testCustomerType2]
        
        let viewModel = ProductListViewModel(
            getProductListUseCase: mockGetProductList,
            getCategoriesUseCase: mockGetCategories,
            getCustomerTypesUseCase: mockGetCustomerTypes
        )
        
        await viewModel.loadInitialData()
        
        // Verify initial state
        #expect(viewModel.selectedCustomerType == testCustomerType1)
        #expect(mockGetProductList.executeCallCount == 1)
        
        // Change customer type - this should trigger an async reload
        viewModel.selectCustomerType(testCustomerType2)
        
        // Wait for the async reload to complete
        try? await Task.sleep(nanoseconds: 10_000_000) // 10ms
        
        // Verify customer type was set
        #expect(viewModel.selectedCustomerType == testCustomerType2)
        #expect(mockGetProductList.executeCallCount == 2)
        #expect(viewModel.state == .loaded)
    }
    
    // MARK: - Currency Selection Tests
    
    @Test("Selects currency correctly")
    func testSelectsCurrency() async {
        let mockGetProductList = MockGetProductListUseCase()
        let mockGetCategories = MockGetCategoriesUseCase()
        let mockGetCustomerTypes = MockGetCustomerTypesUseCase()
        
        let viewModel = ProductListViewModel(
            getProductListUseCase: mockGetProductList,
            getCategoriesUseCase: mockGetCategories,
            getCustomerTypesUseCase: mockGetCustomerTypes
        )
        
        viewModel.selectCurrency(Currency.eur)
        
        #expect(viewModel.selectedCurrency == Currency.eur)
    }
    
    // MARK: - Quantity Update Tests
    
    @Test("Updates product quantity correctly")
    func testUpdatesProductQuantity() async {
        let mockGetProductList = MockGetProductListUseCase()
        let products = testProducts
        mockGetProductList.mockProducts = products
        let mockGetCategories = MockGetCategoriesUseCase()
        let mockGetCustomerTypes = MockGetCustomerTypesUseCase()
        mockGetCustomerTypes.mockCustomerTypes = [testCustomerType1]
        
        let viewModel = ProductListViewModel(
            getProductListUseCase: mockGetProductList,
            getCategoriesUseCase: mockGetCategories,
            getCustomerTypesUseCase: mockGetCustomerTypes
        )
        
        await viewModel.loadInitialData()
        
        // Ensure we have products displayed
        #expect(viewModel.displayedProducts.count > 0)
        
        let productId = products[0].id
        viewModel.updateProductQuantity(productId, quantity: 3)
        
        let updatedProduct = viewModel.displayedProducts.first { $0.id == productId }
        #expect(updatedProduct?.quantity == 3)
    }
    
    @Test("Enforces maximum quantity limit")
    func testEnforcesMaximumQuantityLimit() async {
        let mockGetProductList = MockGetProductListUseCase()
        let products = testProducts
        mockGetProductList.mockProducts = products
        let mockGetCategories = MockGetCategoriesUseCase()
        let mockGetCustomerTypes = MockGetCustomerTypesUseCase()
        mockGetCustomerTypes.mockCustomerTypes = [testCustomerType1]
        
        let viewModel = ProductListViewModel(
            getProductListUseCase: mockGetProductList,
            getCategoriesUseCase: mockGetCategories,
            getCustomerTypesUseCase: mockGetCustomerTypes
        )
        
        await viewModel.loadInitialData()
        
        // Ensure we have products displayed
        #expect(viewModel.displayedProducts.count > 0)
        
        let productId = products[0].id
        viewModel.updateProductQuantity(productId, quantity: 15) // Exceeds max of 10
        
        let updatedProduct = viewModel.displayedProducts.first { $0.id == productId }
        #expect(updatedProduct?.quantity == 10)
    }
    
    // MARK: - Totals Calculation Tests
    
    @Test("Calculates totals correctly for different currencies")
    func testCalculatesTotalsForDifferentCurrencies() async {
        let mockGetProductList = MockGetProductListUseCase()
        let products = testProducts
        mockGetProductList.mockProducts = products
        let mockGetCategories = MockGetCategoriesUseCase()
        let mockGetCustomerTypes = MockGetCustomerTypesUseCase()
        mockGetCustomerTypes.mockCustomerTypes = [testCustomerType1]
        
        let viewModel = ProductListViewModel(
            getProductListUseCase: mockGetProductList,
            getCategoriesUseCase: mockGetCategories,
            getCustomerTypesUseCase: mockGetCustomerTypes
        )
        
        await viewModel.loadInitialData()
        
        // Add quantities to products
        let product1Id = products[0].id
        let product2Id = products[1].id
        viewModel.updateProductQuantity(product1Id, quantity: 2)
        viewModel.updateProductQuantity(product2Id, quantity: 1)
        
        // Check USD total (10.99 * 2 + 12.99 * 1 = 34.97)
        viewModel.selectCurrency(Currency.usd)
        #expect(viewModel.totalAmount == 34.97)
        
        // Check EUR total (9.99 * 2 + 11.99 * 1 = 31.97)
        viewModel.selectCurrency(Currency.eur)
        #expect(viewModel.totalAmount == 31.97)
        
        // Check GBP total (8.99 * 2 + 10.99 * 1 = 28.97)
        viewModel.selectCurrency(Currency.gbp)
        #expect(viewModel.totalAmount == 28.97)
    }
    
    @Test("Returns zero total when no products in cart")
    func testReturnsZeroTotalWhenNoProductsInCart() async {
        let mockGetProductList = MockGetProductListUseCase()
        mockGetProductList.mockProducts = testProducts
        let mockGetCategories = MockGetCategoriesUseCase()
        let mockGetCustomerTypes = MockGetCustomerTypesUseCase()
        mockGetCustomerTypes.mockCustomerTypes = [testCustomerType1]
        
        let viewModel = ProductListViewModel(
            getProductListUseCase: mockGetProductList,
            getCategoriesUseCase: mockGetCategories,
            getCustomerTypesUseCase: mockGetCustomerTypes
        )
        
        await viewModel.loadInitialData()
        
        #expect(viewModel.totalAmount == 0)
    }
}
