//
//  CartStateManagerTests.swift
//  fly-shop-unit-tests
//
//  Created by Olga Covaliova on 23.10.2025.
//

import Testing
import SwiftUI
@testable import fly_shop

@MainActor
struct CartStateManagerTests {
    
    // MARK: - Test Cases
    
    @Test("Initial state should be loading")
    func testInitialState() {
        let manager = CartStateService()
        #expect(manager.state == .loading)
        #expect(manager.error == nil)
    }
    
    @Test("Update state with empty products should set empty state")
    func testUpdateStateWithEmptyProducts() {
        let manager = CartStateService()
        manager.updateState(products: [])
        #expect(manager.state == .empty)
    }
    
    @Test("Update state with products should set loaded state")
    func testUpdateStateWithProducts() {
        let manager = CartStateService()
        let category = Category(name: "Test Category", key: "test")
        let customerType = CustomerType(key: "test", name: "Test Customer")
        let products = [Product(
            name: "Test Product",
            prices: [.usd: 10.0],
            imageURL: "https://example.com/image.jpg",
            category: category,
            customerType: customerType
        )]
        manager.updateState(products: products)
        #expect(manager.state == .loaded)
    }
    
    @Test("State transitions work correctly")
    func testStateTransitions() {
        let manager = CartStateService()
        let category = Category(name: "Test Category", key: "test")
        let customerType = CustomerType(key: "test", name: "Test Customer")
        let products = [Product(
            name: "Test Product",
            prices: [.usd: 10.0],
            imageURL: "https://example.com/image.jpg",
            category: category,
            customerType: customerType
        )]
        
        // Loading -> Empty
        manager.updateState(products: [])
        #expect(manager.state == .empty)
        
        // Empty -> Loaded
        manager.updateState(products: products)
        #expect(manager.state == .loaded)
        
        // Loaded -> Empty
        manager.updateState(products: [])
        #expect(manager.state == .empty)
    }
}
