//
//  CompositionRootTests.swift
//  FlyShopUnitTests
//
//  Created by Olga Covaliova on 17.10.2025.
//

import Testing
import SwiftUI
@testable import fly_shop

struct CompositionRootTests {
    
    @Test("Should return different instances on multiple calls")
    @MainActor func testInstanceCreation() async {
        let compositionRoot = CompositionRoot()
        let viewModel1 = compositionRoot.makeProductListViewModel()
        let viewModel2 = compositionRoot.makeProductListViewModel()
        
        // Should return different instances (not singleton)
        #expect(viewModel1 !== viewModel2)
    }
    
    @Test("Should create view model without throwing")
    @MainActor func testMakeProductListViewModelDoesNotThrow() async {
        let compositionRoot = CompositionRoot()
        
        // Test that the method doesn't throw an exception
        #expect(throws: Never.self) {
            let _ = compositionRoot.makeProductListViewModel()
        }
    }
    
    @Test("Should create cart view models with shared session service")
    @MainActor func testCartViewModelsShareSessionService() async {
        let compositionRoot = CompositionRoot()
        
        // Create first cart view model and update seat
        let viewModel1 = compositionRoot.makeCartViewViewModel(
            selectedCurrency: .usd
        )
        viewModel1.selectedSeat = "B 3"
        
        // Create second cart view model
        let viewModel2 = compositionRoot.makeCartViewViewModel(
            selectedCurrency: .eur
        )
        
        // Second view model should have the seat from the first one
        #expect(viewModel2.selectedSeat == "B 3")
    }
    
    @Test("Should return different instances for payment view models")
    @MainActor func testPaymentViewModelsReturnDifferentInstances() async {
        let compositionRoot = CompositionRoot()
        
        let cashViewModel1 = compositionRoot.makeCashPaymentViewModel(
            totalAmount: 100.00,
            currency: .usd
        )
        let cashViewModel2 = compositionRoot.makeCashPaymentViewModel(
            totalAmount: 200.00,
            currency: .eur
        )
        
        let cardViewModel1 = compositionRoot.makeCardPaymentViewModel(
            totalAmount: 100.00,
            currency: .usd
        )
        let cardViewModel2 = compositionRoot.makeCardPaymentViewModel(
            totalAmount: 200.00,
            currency: .eur
        )
        
        // Should return different instances
        #expect(cashViewModel1 !== cashViewModel2)
        #expect(cardViewModel1 !== cardViewModel2)
    }
    
    @Test("Should create multiple cart view models with different currencies")
    @MainActor func testCartViewModelsWithDifferentCurrencies() async {
        let compositionRoot = CompositionRoot()
        
        let usdViewModel = compositionRoot.makeCartViewViewModel(selectedCurrency: .usd)
        let eurViewModel = compositionRoot.makeCartViewViewModel(selectedCurrency: .eur)
        let gbpViewModel = compositionRoot.makeCartViewViewModel(selectedCurrency: .gbp)
        
        // All should be different instances
        #expect(usdViewModel !== eurViewModel)
        #expect(usdViewModel !== gbpViewModel)
        #expect(eurViewModel !== gbpViewModel)
    }
    
    @Test("Should maintain singleton behavior for services through multiple view model creations")
    @MainActor func testServicesSingletonBehavior() async {
        let compositionRoot = CompositionRoot()
        
        // Create multiple cart view models - they should share the same session service
        let cartViewModel1 = compositionRoot.makeCartViewViewModel(selectedCurrency: .usd)
        let cartViewModel2 = compositionRoot.makeCartViewViewModel(selectedCurrency: .eur)
        
        // Update seat in first view model
        cartViewModel1.selectedSeat = "A 1"
        
        // Second view model should reflect the change (shared session service)
        #expect(cartViewModel2.selectedSeat == "A 1")
        
        // Create another cart view model and verify it also has the shared state
        let cartViewModel3 = compositionRoot.makeCartViewViewModel(selectedCurrency: .gbp)
        #expect(cartViewModel3.selectedSeat == "A 1")
    }
    
    @Test("Should create view models with all supported currencies")
    @MainActor func testViewModelsWithAllCurrencies() async {
        let compositionRoot = CompositionRoot()
        let currencies: [Currency] = [.usd, .eur, .gbp]
        
        for currency in currencies {
            // Test cart view model
            let cartViewModel = compositionRoot.makeCartViewViewModel(selectedCurrency: currency)
            #expect(cartViewModel.selectedCurrency == currency)
            
            // Test payment view models
            let cashViewModel = compositionRoot.makeCashPaymentViewModel(
                totalAmount: 100.00,
                currency: currency
            )
            let cardViewModel = compositionRoot.makeCardPaymentViewModel(
                totalAmount: 100.00,
                currency: currency
            )
            
            #expect(cashViewModel.currency == currency)
            #expect(cardViewModel.currency == currency)
        }
    }
    
    // MARK: - Helper Methods
    
    private func createTestProducts() -> [Product] {
        let category = Category(name: "Test", key: "test")
        let customerType = CustomerType(key: "standard", name: "Standard")
        
        return [
            Product(
                id: UUID(),
                name: "Test Product",
                prices: [.usd: 10.00, .eur: 9.00, .gbp: 8.00],
                imageURL: "test.jpg",
                category: category,
                quantity: 1,
                customerType: customerType
            )
        ]
    }
}
