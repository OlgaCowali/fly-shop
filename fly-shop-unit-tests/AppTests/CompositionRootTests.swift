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
