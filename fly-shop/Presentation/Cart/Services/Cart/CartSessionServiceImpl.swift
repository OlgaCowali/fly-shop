//
//  CartSessionService.swift
//  fly-shop
//
//  Created by Olga Covaliova on 23.10.2025.
//

import Foundation
import Combine

// Service responsible for managing cart session state during the app lifecycle
final class CartSessionServiceImpl: CartSessionService, ObservableObject {
    @Published private(set) var selectedProducts: [Product] = []
    @Published var selectedSeat: String
    
    var selectedProductsPublisher: AnyPublisher<[Product], Never> {
        $selectedProducts.eraseToAnyPublisher()
    }
    
    init(defaultSeat: String = "A 1") {
        self.selectedSeat = defaultSeat
    }
    
    // Adds or updates a product in the cart
    func addProduct(_ product: Product) {
        if let index = selectedProducts.firstIndex(where: { $0.id == product.id }) {
            selectedProducts[index] = product
        } else {
            selectedProducts.append(product)
        }
    }
    
    // Removes a product from the cart
    func removeProduct(productId: UUID) {
        selectedProducts.removeAll { $0.id == productId }
    }
    
    // Updates product quantity in the cart
    func updateProductQuantity(_ productId: UUID, quantity: Int) {
        guard let index = selectedProducts.firstIndex(where: { $0.id == productId }) else {
            return
        }
        
        if quantity <= 0 {
            selectedProducts.remove(at: index)
        } else {
            selectedProducts[index].quantity = quantity
        }
    }

    // Updates the selected seat number
    func updateSeat(_ seat: String) {
        selectedSeat = seat
    }
    
    // Clears all products from the cart
    func clearCart() {
        selectedProducts.removeAll()
    }
}
