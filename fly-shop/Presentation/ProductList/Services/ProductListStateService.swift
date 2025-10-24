//
//  ProductListStateManager.swift
//  fly-shop
//
//  Created by Olga Covaliova on 24.10.2025.
//

import SwiftUI
import Foundation

final class ProductListStateService: ObservableObject {
    @Published private(set) var state: ViewState = .loading
    @Published private(set) var error: DomainError?
    
    // MARK: - Public Methods
    
    func setLoading() {
        state = .loading
        error = nil
    }
    
    func setLoaded() {
        // If there's an error, keep the error state
        if let error = error {
            state = .error(error)
            return
        }
        
        state = .loaded
    }
    
    func setError(_ error: DomainError) {
        self.error = error
        state = .error(error)
    }
    
    func updateState(products: [Product]) {
        // If there's an error, keep the error state
        if let error = error {
            state = .error(error)
            return
        }
        
        // Determine state based on products content
        if products.isEmpty {
            state = .empty
        } else {
            state = .loaded
        }
    }
}
