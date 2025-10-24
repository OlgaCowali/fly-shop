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
        let mockCashPaymentService = MockCashPaymentService()
        let mockCardPaymentService = MockCardPaymentService()
        let mockStateService = MockCartStateService()
        let viewModel = CartViewViewModel(
            selectedCurrency: .usd,
            sessionService: mockSessionService,
            paymentService: mockCashPaymentService,
            cardPaymentService: mockCardPaymentService,
            stateManager: mockStateService
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
        let mockCashPaymentService = MockCashPaymentService()
        let mockCardPaymentService = MockCardPaymentService()
        let mockStateService = MockCartStateService()
        let viewModel = CartViewViewModel(
            selectedCurrency: .usd,
            sessionService: mockSessionService,
            paymentService: mockCashPaymentService,
            cardPaymentService: mockCardPaymentService,
            stateManager: mockStateService
        )
        
        #expect(viewModel.isDismissed == false)
        
        viewModel.dismiss()
        
        #expect(viewModel.isDismissed == true)
    }
    
    @Test("Selected seat change calls session service")
    func testSelectedSeatChangeCallsSessionService() async {
        let mockSessionService = MockCartSessionService()
        let mockCashPaymentService = MockCashPaymentService()
        let mockCardPaymentService = MockCardPaymentService()
        let mockStateService = MockCartStateService()
        let viewModel = CartViewViewModel(
            selectedCurrency: .usd,
            sessionService: mockSessionService,
            paymentService: mockCashPaymentService,
            cardPaymentService: mockCardPaymentService,
            stateManager: mockStateService
        )
        
        #expect(mockSessionService.updateSeatCallCount == 0)
        
        viewModel.selectedSeat = "B 2"
        
        #expect(mockSessionService.updateSeatCallCount == 1)
        #expect(mockSessionService.updateSeatCalledWithSeat == "B 2")
    }
    
    // MARK: - Computed Properties Tests
    
    @Test("Selected products returns session service products")
    func testSelectedProductsReturnsSessionServiceProducts() async {
        let mockSessionService = MockCartSessionService()
        let mockCashPaymentService = MockCashPaymentService()
        let mockCardPaymentService = MockCardPaymentService()
        let mockStateService = MockCartStateService()
        let product1 = createTestProduct(name: "Product 1")
        let product2 = createTestProduct(name: "Product 2")
        
        mockSessionService.selectedProducts = [product1, product2]
        
        let viewModel = CartViewViewModel(
            selectedCurrency: .usd,
            sessionService: mockSessionService,
            paymentService: mockCashPaymentService,
            cardPaymentService: mockCardPaymentService,
            stateManager: mockStateService
        )
        
        #expect(viewModel.selectedProducts.count == 2)
        #expect(viewModel.selectedProducts.contains(product1))
        #expect(viewModel.selectedProducts.contains(product2))
    }
    
    // MARK: - Public Methods Tests
    
    @Test("Remove product calls session service")
    func testRemoveProductCallsSessionService() async {
        let mockSessionService = MockCartSessionService()
        let mockCashPaymentService = MockCashPaymentService()
        let mockCardPaymentService = MockCardPaymentService()
        let mockStateService = MockCartStateService()
        let productId = UUID()
        let viewModel = CartViewViewModel(
            selectedCurrency: .usd,
            sessionService: mockSessionService,
            paymentService: mockCashPaymentService,
            cardPaymentService: mockCardPaymentService,
            stateManager: mockStateService
        )
        
        viewModel.removeProduct(productId: productId)
        
        #expect(mockSessionService.removeProductCallCount == 1)
        #expect(mockSessionService.removeProductCalledWithId == productId)
    }
    
    
    // MARK: - Currency Tests
    
    @Test("Currency change updates total calculation")
    func testCurrencyChangeUpdatesTotalCalculation() async {
        let mockSessionService = MockCartSessionService()
        let mockCashPaymentService = MockCashPaymentService()
        let mockCardPaymentService = MockCardPaymentService()
        let mockStateService = MockCartStateService()
        let product = createTestProduct(
            prices: [.usd: 10.0, .eur: 9.0, .gbp: 8.0],
            quantity: 2
        )
        mockSessionService.selectedProducts = [product]
        
        let viewModel = CartViewViewModel(
            selectedCurrency: .usd,
            sessionService: mockSessionService,
            paymentService: mockCashPaymentService,
            cardPaymentService: mockCardPaymentService,
            stateManager: mockStateService
        )
        
        #expect(viewModel.totalAmount == 20.0) // 10.0 * 2
        
        viewModel.selectedCurrency = .eur
        
        #expect(viewModel.totalAmount == 18.0) // 9.0 * 2
        
        viewModel.selectedCurrency = .gbp
        
        #expect(viewModel.totalAmount == 16.0) // 8.0 * 2
    }
    
    // MARK: - Payment Tests
    
    @Test("Show cash payment with empty cart shows alert")
    func testShowCashPaymentWithEmptyCartShowsAlert() async {
        let mockSessionService = MockCartSessionService()
        let mockCashPaymentService = MockCashPaymentService()
        let mockCardPaymentService = MockCardPaymentService()
        let mockStateService = MockCartStateService()
        let viewModel = CartViewViewModel(
            selectedCurrency: .usd,
            sessionService: mockSessionService,
            paymentService: mockCashPaymentService,
            cardPaymentService: mockCardPaymentService,
            stateManager: mockStateService
        )
        
        #expect(viewModel.showEmptyCartAlert == false)
        
        viewModel.showCashPayment()
        
        #expect(viewModel.showEmptyCartAlert == true)
        #expect(viewModel.showCashPaymentView == false)
    }
    
    @Test("Show cash payment with products creates view model")
    func testShowCashPaymentWithProductsCreatesViewModel() async {
        let mockSessionService = MockCartSessionService()
        let mockCashPaymentService = MockCashPaymentService()
        let mockCardPaymentService = MockCardPaymentService()
        let mockStateService = MockCartStateService()
        let product = createTestProduct(prices: [.usd: 10.0], quantity: 1)
        mockSessionService.selectedProducts = [product]
        
        let viewModel = CartViewViewModel(
            selectedCurrency: .usd,
            sessionService: mockSessionService,
            paymentService: mockCashPaymentService,
            cardPaymentService: mockCardPaymentService,
            stateManager: mockStateService
        )
        
        #expect(viewModel.showCashPaymentView == false)
        #expect(viewModel.cashPaymentViewModel == nil)
        
        viewModel.showCashPayment()
        
        #expect(viewModel.showCashPaymentView == true)
        #expect(viewModel.cashPaymentViewModel != nil)
    }
    
    @Test("Hide cash payment resets state")
    func testHideCashPaymentResetsState() async {
        let mockSessionService = MockCartSessionService()
        let mockCashPaymentService = MockCashPaymentService()
        let mockCardPaymentService = MockCardPaymentService()
        let mockStateService = MockCartStateService()
        let product = createTestProduct(prices: [.usd: 10.0], quantity: 1)
        mockSessionService.selectedProducts = [product]
        
        let viewModel = CartViewViewModel(
            selectedCurrency: .usd,
            sessionService: mockSessionService,
            paymentService: mockCashPaymentService,
            cardPaymentService: mockCardPaymentService,
            stateManager: mockStateService
        )
        
        viewModel.showCashPayment()
        #expect(viewModel.showCashPaymentView == true)
        #expect(viewModel.cashPaymentViewModel != nil)
        
        viewModel.hideCashPayment()
        
        #expect(viewModel.showCashPaymentView == false)
        #expect(viewModel.cashPaymentViewModel == nil)
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
