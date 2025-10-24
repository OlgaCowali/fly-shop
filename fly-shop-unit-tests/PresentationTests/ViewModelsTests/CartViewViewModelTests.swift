//
//  CartViewViewModelTests.swift
//  fly-shop-unit-tests
//
//  Created by Olga Covaliova on 23.10.2025.
//

import Testing
import SwiftUI
@testable import fly_shop

@MainActor
struct CartViewViewModelTests {
    // MARK: - Initialization Tests
    
    @Test("Initialization with default state manager")
    func testInitializationWithDefaultStateManager() async {
        let mockSessionService = MockCartSessionService()
        let viewModel = CartViewViewModel(
            selectedCurrency: .usd,
            sessionService: mockSessionService
        )
        
        #expect(viewModel.selectedCurrency == .usd)
        #expect(viewModel.selectedSeat == "A 1")
        #expect(viewModel.isDismissed == false)
        #expect(viewModel.selectedProducts.isEmpty)
        #expect(viewModel.totalAmount == 0)
    }
    
    // MARK: - Published Properties Tests
    
    @Test("Dismiss sets isDismissed to true")
    func testDismissSetsIsDismissedToTrue() async {
        let mockSessionService = MockCartSessionService()
        let viewModel = CartViewViewModel(
            selectedCurrency: .usd,
            sessionService: mockSessionService
        )
        
        #expect(viewModel.isDismissed == false)
        
        viewModel.dismiss()
        
        #expect(viewModel.isDismissed == true)
    }
    
    // MARK: - Computed Properties Tests
    
    @Test("Selected products returns session service products")
    func testSelectedProductsReturnsSessionServiceProducts() async {
        let mockSessionService = MockCartSessionService()
        let product1 = createTestProduct(name: "Product 1")
        let product2 = createTestProduct(name: "Product 2")
        
        mockSessionService.selectedProducts = [product1, product2]
        
        let viewModel = CartViewViewModel(
            selectedCurrency: .usd,
            sessionService: mockSessionService
        )
        
        #expect(viewModel.selectedProducts.count == 2)
        #expect(viewModel.selectedProducts.contains(product1))
        #expect(viewModel.selectedProducts.contains(product2))
    }
    
    // MARK: - Public Methods Tests
    
    @Test("Remove product calls session service")
    func testRemoveProductCallsSessionService() async {
        let mockSessionService = MockCartSessionService()
        let productId = UUID()
        let viewModel = CartViewViewModel(
            selectedCurrency: .usd,
            sessionService: mockSessionService
        )
        
        viewModel.removeProduct(productId: productId)
        
        #expect(mockSessionService.removeProductCallCount == 1)
        #expect(mockSessionService.removeProductCalledWithId == productId)
    }
    
    
    // MARK: - Currency Tests
    
    @Test("Currency change updates total calculation")
    func testCurrencyChangeUpdatesTotalCalculation() async {
        let mockSessionService = MockCartSessionService()
        let product = createTestProduct(
            prices: [.usd: 10.0, .eur: 9.0, .gbp: 8.0],
            quantity: 2
        )
        mockSessionService.selectedProducts = [product]
        
        let viewModel = CartViewViewModel(
            selectedCurrency: .usd,
            sessionService: mockSessionService
        )
        
        #expect(viewModel.totalAmount == 20.0) // 10.0 * 2
        
        viewModel.selectedCurrency = .eur
        
        #expect(viewModel.totalAmount == 18.0) // 9.0 * 2
        
        viewModel.selectedCurrency = .gbp
        
        #expect(viewModel.totalAmount == 16.0) // 8.0 * 2
    }
    
    // MARK: - Helper Methods

    private func createTestProduct(
        id: UUID = UUID(),
        name: String = "Test Product",
        prices: [Currency: Decimal] = [.usd: 10.0, .eur: 9.0, .gbp: 8.0],
        quantity: Int = 1
    ) -> Product {
        Product(
            id: id,
            name: name,
            prices: prices,
            imageURL: "test.jpg",
            category: Category(name: "Test", key: "test"),
            quantity: quantity,
            customerType: CustomerType(key: "adult", name: "Adult", isDefault: true)
        )
    }
}
