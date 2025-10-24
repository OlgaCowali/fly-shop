//
//  MockCartSessionService.swift
//  fly-shop-unit-tests
//
//  Created by Olga Covaliova on 23.10.2025.
//

import Foundation
import Combine
@testable import fly_shop

final class MockCartSessionService: CartSessionService {
    
    // MARK: - Properties
    
    @Published var selectedProducts: [Product] = []
    var selectedSeat: String = "A 1"
    var selectedProductsPublisher: AnyPublisher<[Product], Never> {
        $selectedProducts.eraseToAnyPublisher()
    }
    
    // MARK: - Call Tracking
    
    var addProductCallCount = 0
    var addProductCalledWithProduct: Product?
    var removeProductCallCount = 0
    var removeProductCalledWithId: UUID?
    var updateProductQuantityCallCount = 0
    var updateProductQuantityCalledWithId: UUID?
    var updateProductQuantityCalledWithQuantity: Int?
    var updateSeatCallCount = 0
    var updateSeatCalledWithSeat: String?
    var clearCartCallCount = 0
    var resetSessionCallCount = 0
    
    // MARK: - Initialization
    
    init() {}
    
    // MARK: - CartSessionServiceProtocol Implementation
    
    func addProduct(_ product: Product) {
        addProductCallCount += 1
        addProductCalledWithProduct = product
        
        if let index = selectedProducts.firstIndex(where: { $0.id == product.id }) {
            selectedProducts[index] = product
        } else {
            selectedProducts.append(product)
        }
    }
    
    func removeProduct(productId: UUID) {
        removeProductCallCount += 1
        removeProductCalledWithId = productId
        selectedProducts.removeAll { $0.id == productId }
    }
    
    func updateProductQuantity(_ productId: UUID, quantity: Int) {
        updateProductQuantityCallCount += 1
        updateProductQuantityCalledWithId = productId
        updateProductQuantityCalledWithQuantity = quantity
        
        guard let index = selectedProducts.firstIndex(where: { $0.id == productId }) else {
            return
        }
        
        if quantity <= 0 {
            selectedProducts.remove(at: index)
        } else {
            selectedProducts[index].quantity = quantity
        }
    }
    
    func updateSeat(_ seat: String) {
        updateSeatCallCount += 1
        updateSeatCalledWithSeat = seat
        selectedSeat = seat
    }
    
    func clearCart() {
        clearCartCallCount += 1
        selectedProducts.removeAll()
    }
    
    func resetSession() {
        resetSessionCallCount += 1
        selectedSeat = "A 1"
        selectedProducts.removeAll()
    }
    
    // MARK: - Helper Methods
    
    @MainActor
    func reset() {
        selectedSeat = "A 1"
        selectedProducts = []
        addProductCallCount = 0
        addProductCalledWithProduct = nil
        removeProductCallCount = 0
        removeProductCalledWithId = nil
        updateProductQuantityCallCount = 0
        updateProductQuantityCalledWithId = nil
        updateProductQuantityCalledWithQuantity = nil
        updateSeatCallCount = 0
        updateSeatCalledWithSeat = nil
        clearCartCallCount = 0
        resetSessionCallCount = 0
    }
}

