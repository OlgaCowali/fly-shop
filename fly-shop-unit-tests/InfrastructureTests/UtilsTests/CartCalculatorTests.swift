//
//  CartCalculatorTests.swift
//  FlyShopUnitTests
//
//  Created by Olga Covaliova on 20.10.2025.
//

import Testing
import Foundation
@testable import fly_shop

struct CartCalculatorTests {
    
    @Test("calculateTotals should calculate correct totals for products")
    func testCalculateTotals() {
        let product = createTestProduct(usdPrice: 25.50, eurPrice: 23.00, gbpPrice: 20.00, quantity: 2)
        let products = [product]
        let currencies: [Currency] = [.usd, .eur, .gbp]
        
        let result = CartCalculator.calculateTotals(for: products, currencies: currencies)
        
        #expect(result[.usd] == 51.00)
        #expect(result[.eur] == 46.00)
        #expect(result[.gbp] == 40.00)
    }
    
    @Test("calculateTotals should ignore products with zero quantity")
    func testCalculateTotalsZeroQuantity() {
        let product1 = createTestProduct(quantity: 0)
        let product2 = createTestProduct(quantity: 2)
        let products = [product1, product2]
        let currencies: [Currency] = [.usd, .eur, .gbp]
        
        let result = CartCalculator.calculateTotals(for: products, currencies: currencies)
        
        #expect(result[.usd] == 20.00)
        #expect(result[.eur] == 18.00)
        #expect(result[.gbp] == 16.00)
    }
    
    @Test("calculateTotalPayment should calculate correct total for a single product")
    func testCalculateTotalPayment() {
        let product = createTestProduct(usdPrice: 15.50, quantity: 3)
        
        let result = CartCalculator.calculateTotalPayment(for: product, currency: .usd)
        
        #expect(result == 46.50)
    }
    
    @Test("calculateTotalPayment should return zero for product with zero quantity")
    func testCalculateTotalPaymentZeroQuantity() {
        let product = createTestProduct(usdPrice: 10.00, quantity: 0)
        
        let result = CartCalculator.calculateTotalPayment(for: product, currency: .usd)
        
        #expect(result == 0)
    }
    
    private func createTestProduct(
        id: UUID = UUID(),
        usdPrice: Decimal = 10.00,
        eurPrice: Decimal = 9.00,
        gbpPrice: Decimal = 8.00,
        quantity: Int = 1
    ) -> Product {
        return Product(
            id: id,
            name: "Test Product",
            prices: [.usd: usdPrice, .eur: eurPrice, .gbp: gbpPrice],
            imageURL: "test.jpg",
            category: Category(name: "Test", key: "test"),
            quantity: quantity,
            customerType: CustomerType(key: "standard", name: "Standard")
        )
    }
}
