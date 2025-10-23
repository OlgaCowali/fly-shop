//
//  CartCalculator.swift
//  fly-shop
//
//  Created by Olga Covaliova on 20.10.2025.
//

import Foundation

// Utility class for cart-related calculations and operations
final class CartCalculator {
    
    // Calculates totals for all currencies based on products and their quantities
    static func calculateTotals(for products: [Product], currencies: [Currency]) -> [Currency: Decimal] {
        var totals: [Currency: Decimal] = [:]
        
        for currency in currencies {
            let total = products.reduce(Decimal(0)) { sum, product in
                guard let unitPrice = product.prices[currency], product.quantity > 0 else { return sum }
                return sum + (unitPrice * Decimal(product.quantity))
            }
            totals[currency] = total
        }
        
        return totals
    }
    
    // Updates the quantity of a specific product in the products array
    static func updateProductQuantity(in products: inout [Product], productId: UUID, quantity: Int) -> Bool {
        guard let index = products.firstIndex(where: { $0.id == productId }) else {
            return false
        }
        
        products[index].quantity = quantity
        return true
    }
    
    // Updates the quantity of a specific product in both stored and displayed product arrays
    static func updateProductQuantityInBothArrays(
        storedProducts: inout [Product],
        displayedProducts: inout [Product],
        productId: UUID,
        quantity: Int
    ) -> Bool {
        // Update in stored products
        guard updateProductQuantity(in: &storedProducts, productId: productId, quantity: quantity) else {
            return false
        }
        
        // Update in displayed products if it exists there
        if let displayedIndex = displayedProducts.firstIndex(where: { $0.id == productId }) {
            displayedProducts[displayedIndex].quantity = quantity
        }

        return true
    }
}
