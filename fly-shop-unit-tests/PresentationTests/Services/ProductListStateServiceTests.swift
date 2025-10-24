//
//  ProductListStateServiceTests.swift
//  fly-shop
//
//  Created by Olga Covaliova on 24.10.2025.
//

import Testing
import Foundation
@testable import fly_shop

@MainActor
struct ProductListStateServiceTests {
    
    // MARK: - Initial State Tests
    
    @Test("Initial state should be loading")
    func testInitialState() {
        let service = ProductListStateService()
        #expect(service.state == .loading)
        #expect(service.error == nil)
    }
    
    // MARK: - State Management Tests
    
    @Test("setLoading should set state to loading and clear error")
    func testSetLoading() {
        let service = ProductListStateService()
        service.setError(.network)
        
        service.setLoading()
        
        #expect(service.state == .loading)
        #expect(service.error == nil)
    }
    
    @Test("setLoaded should set state to loaded when no error")
    func testSetLoadedWithoutError() {
        let service = ProductListStateService()
        
        service.setLoaded()
        
        #expect(service.state == .loaded)
    }
    
    @Test("setLoaded should keep error state when error exists")
    func testSetLoadedWithError() {
        let service = ProductListStateService()
        service.setError(.network)
        
        service.setLoaded()
        
        #expect(service.state == .error(.network))
        #expect(service.error == .network)
    }
    
    @Test("setError should set error state and store error")
    func testSetError() {
        let service = ProductListStateService()
        
        service.setError(.network)
        
        #expect(service.state == .error(.network))
        #expect(service.error == .network)
    }
    
    // MARK: - Update State Tests
    
    @Test("updateState with empty products should set empty state when no error")
    func testUpdateStateWithEmptyProducts() {
        let service = ProductListStateService()
        
        service.updateState(products: [])
        
        #expect(service.state == .empty)
    }
    
    @Test("updateState with products should set loaded state when no error")
    func testUpdateStateWithProducts() {
        let service = ProductListStateService()
        let products = [
            Product(name: "Test", prices: [:], imageURL: "", category: Category(name: "Test", key: "test"), customerType: CustomerType(key: "regular", name: "Regular"))
        ]
        
        service.updateState(products: products)
        
        #expect(service.state == .loaded)
    }
    
    @Test("updateState should keep error state when error exists")
    func testUpdateStateWithError() {
        let service = ProductListStateService()
        service.setError(.server)
        let products = [
            Product(name: "Test", prices: [:], imageURL: "", category: Category(name: "Test", key: "test"), customerType: CustomerType(key: "regular", name: "Regular"))
        ]
        
        service.updateState(products: products)
        
        #expect(service.state == .error(.server))
        #expect(service.error == .server)
    }
    
    @Test("updateState with empty products should keep error state when error exists")
    func testUpdateStateWithEmptyProductsAndError() {
        let service = ProductListStateService()
        service.setError(.unauthorized)
        
        service.updateState(products: [])
        
        #expect(service.state == .error(.unauthorized))
        #expect(service.error == .unauthorized)
    }
    
}
