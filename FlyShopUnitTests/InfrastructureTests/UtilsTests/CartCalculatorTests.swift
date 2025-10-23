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
    
    @Test("updateProductQuantity should update quantity for existing product")
    func testUpdateProductQuantity() {
        let productId = UUID()
        var products = [createTestProduct(id: productId, quantity: 1)]
        
        let result = CartCalculator.updateProductQuantity(in: &products, productId: productId, quantity: 5)
        
        #expect(result == true)
        #expect(products[0].quantity == 5)
    }
    
    @Test("updateProductQuantity should return false for non-existing product")
    func testUpdateProductQuantityNonExisting() {
        let nonExistingId = UUID()
        var products = [createTestProduct(quantity: 1)]
        
        let result = CartCalculator.updateProductQuantity(in: &products, productId: nonExistingId, quantity: 5)
        
        #expect(result == false)
        #expect(products[0].quantity == 1)
    }
    
    @Test("updateProductQuantityInBothArrays should update both arrays")
    func testUpdateProductQuantityInBothArrays() {
        let productId = UUID()
        var storedProducts = [createTestProduct(id: productId, quantity: 1)]
        var displayedProducts = [createTestProduct(id: productId, quantity: 1)]
        
        let result = CartCalculator.updateProductQuantityInBothArrays(
            storedProducts: &storedProducts,
            displayedProducts: &displayedProducts,
            productId: productId,
            quantity: 5
        )
        
        #expect(result == true)
        #expect(storedProducts[0].quantity == 5)
        #expect(displayedProducts[0].quantity == 5)
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
