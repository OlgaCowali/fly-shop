//
//  CartStateManager.swift
//  fly-shop
//
//  Created by Olga Covaliova on 23.10.2025.
//
import SwiftUI
import Foundation

@MainActor
final class CartStateService: CartStateServiceProtocol {
    @Published private(set) var state: ViewState = .loading
    @Published private(set) var error: DomainError?
    
    // MARK: - Public Methods
    
    func updateState(products: [Product]) {
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
        error = nil
    }
}
