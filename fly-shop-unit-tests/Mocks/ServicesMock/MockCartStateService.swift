//
//  MockCartStateService.swift
//  fly-shop-unit-tests
//
//  Created by Olga Covaliova on 24.10.2025.
//

import Foundation
import SwiftUI
@testable import fly_shop

@MainActor
final class MockCartStateService: CartStateServiceProtocol {
    
    // MARK: - Properties
    
    @Published private(set) var state: ViewState = .loading
    @Published private(set) var error: DomainError?
    
    // MARK: - Call Tracking
    
    var updateStateCallCount = 0
    var updateStateCalledWithProducts: [Product]?
    var clearErrorCallCount = 0
    
    // MARK: - Initialization
    
    init() {}
    
    // MARK: - CartStateService Implementation
    
    func updateState(products: [Product]) {
        updateStateCallCount += 1
        updateStateCalledWithProducts = products
        
        // If there's an error, keep the error state
        if let error = error {
            state = .error(error)
            return
        }
        
        // Determine state based on cart content
        if products.isEmpty {
            state = .empty
        } else {
            state = .loaded
        }
    }
    
    func clearError() {
        clearErrorCallCount += 1
        error = nil
    }
    
    // MARK: - Helper Methods
    
    func setError(_ error: DomainError) {
        self.error = error
    }
    
    func reset() {
        state = .loading
        error = nil
        updateStateCallCount = 0
        updateStateCalledWithProducts = nil
        clearErrorCallCount = 0
    }
}
