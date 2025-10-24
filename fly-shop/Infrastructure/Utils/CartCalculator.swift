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
    
    // Calculates the total payment for a specific product (unit price × quantity)
    static func calculateTotalPayment(for product: Product, currency: Currency) -> Decimal {
        guard let unitPrice = product.prices[currency] else {
            return 0
        }
        return unitPrice * Decimal(product.quantity)
    }
}
