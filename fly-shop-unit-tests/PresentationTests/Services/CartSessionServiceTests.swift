//
//  CartSessionServiceTests.swift
//  fly-shop-unit-tests
//
//  Created by Olga Covaliova on 23.10.2025.
//

import Testing
import Foundation
@testable import fly_shop

@MainActor
struct CartSessionServiceTests {
    
    // MARK: - Initialization Tests
    @Test("Initialization with default seat")
    func testInitializationWithDefaultSeat() {
        let service = CartSessionServiceImpl()
        
        #expect(service.selectedSeat == "A 1")
        #expect(service.selectedProducts.isEmpty)
    }
    
    @Test("Initialization with custom seat")
    func testInitializationWithCustomSeat() {
        let service = CartSessionServiceImpl(defaultSeat: "B 5")
        
        #expect(service.selectedSeat == "B 5")
        #expect(service.selectedProducts.isEmpty)
    }
    
    // MARK: - Add Product Tests
    @Test("Add new product to empty cart")
    func testAddNewProductToEmptyCart() {
        let service = CartSessionServiceImpl()
        let product = createTestProduct()
        
        service.addProduct(product)
        
        #expect(service.selectedProducts.count == 1)
        #expect(service.selectedProducts.first?.id == product.id)
        #expect(service.selectedProducts.first?.quantity == product.quantity)
    }
    
    @Test("Add multiple different products")
    func testAddMultipleDifferentProducts() {
        let service = CartSessionServiceImpl()
        let product1 = createTestProduct(name: "Product 1")
        let product2 = createTestProduct(name: "Product 2")
        
        service.addProduct(product1)
        service.addProduct(product2)
        
        #expect(service.selectedProducts.count == 2)
        #expect(service.selectedProducts.contains { $0.id == product1.id })
        #expect(service.selectedProducts.contains { $0.id == product2.id })
    }
    
    @Test("Update existing product")
    func testUpdateExistingProduct() {
        let service = CartSessionServiceImpl()
        let productId = UUID()
        let originalProduct = createTestProduct(id: productId, quantity: 2)
        let updatedProduct = createTestProduct(id: productId, quantity: 5)
        
        service.addProduct(originalProduct)
        service.addProduct(updatedProduct)
        
        #expect(service.selectedProducts.count == 1)
        #expect(service.selectedProducts.first?.quantity == 5)
    }
    
    // MARK: - Remove Product Tests
    @Test("Remove existing product")
    func testRemoveExistingProduct() {
        let service = CartSessionServiceImpl()
        let product = createTestProduct()
        
        service.addProduct(product)
        #expect(service.selectedProducts.count == 1)
        
        service.removeProduct(productId: product.id)
        #expect(service.selectedProducts.isEmpty)
    }
    
    @Test("Remove non-existing product")
    func testRemoveNonExistingProduct() {
        let service = CartSessionServiceImpl()
        let product = createTestProduct()
        
        service.addProduct(product)
        service.removeProduct(productId: UUID()) // Different ID
        
        #expect(service.selectedProducts.count == 1)
    }
    
    @Test("Remove multiple products")
    func testRemoveProductFromMultipleProducts() {
        let service = CartSessionServiceImpl()
        let product1 = createTestProduct(name: "Product 1")
        let product2 = createTestProduct(name: "Product 2")
        let product3 = createTestProduct(name: "Product 3")
        
        service.addProduct(product1)
        service.addProduct(product2)
        service.addProduct(product3)
        
        service.removeProduct(productId: product2.id)
        
        #expect(service.selectedProducts.count == 2)
        #expect(service.selectedProducts.contains { $0.id == product1.id })
        #expect(!service.selectedProducts.contains { $0.id == product2.id })
        #expect(service.selectedProducts.contains { $0.id == product3.id })
    }
    
    // MARK: - Update Product Quantity Tests
    @Test("Update product quantity to positive value")
    func testUpdateProductQuantityToPositiveValue() {
        let service = CartSessionServiceImpl()
        let product = createTestProduct(quantity: 2)
        
        service.addProduct(product)
        service.updateProductQuantity(product.id, quantity: 5)
        
        #expect(service.selectedProducts.first?.quantity == 5)
    }
    
    @Test("Update product quantity to zero removes product")
    func testUpdateProductQuantityToZeroRemovesProduct() {
        let service = CartSessionServiceImpl()
        let product = createTestProduct(quantity: 3)
        
        service.addProduct(product)
        service.updateProductQuantity(product.id, quantity: 0)
        
        #expect(service.selectedProducts.isEmpty)
    }
    
    // MARK: - Update Seat Tests
    @Test("Update seat to new value")
    func testUpdateSeatToNewValue() {
        let service = CartSessionServiceImpl()
        
        service.updateSeat("C 10")
        
        #expect(service.selectedSeat == "C 10")
    }
    
    @Test("Update seat multiple times")
    func testUpdateSeatMultipleTimes() {
        let service = CartSessionServiceImpl()
        
        service.updateSeat("B 5")
        #expect(service.selectedSeat == "B 5")
        
        service.updateSeat("D 15")
        #expect(service.selectedSeat == "D 15")
    }
    
    @Test("Cart state consistency after multiple operations")
    func testCartStateConsistencyAfterMultipleOperations() {
        let service = CartSessionServiceImpl()
        let product1 = createTestProduct(name: "Product 1")
        let product2 = createTestProduct(name: "Product 2")
        let product3 = createTestProduct(name: "Product 3")
        
        // Add all products
        service.addProduct(product1)
        service.addProduct(product2)
        service.addProduct(product3)
        #expect(service.selectedProducts.count == 3)
        
        // Update seat
        service.updateSeat("E 20")
        #expect(service.selectedSeat == "E 20")
        
        // Remove middle product
        service.removeProduct(productId: product2.id)
        #expect(service.selectedProducts.count == 2)
        
        // Update remaining product quantities
        service.updateProductQuantity(product1.id, quantity: 5)
        service.updateProductQuantity(product3.id, quantity: 0) // Should remove
        
        #expect(service.selectedProducts.count == 1)
        #expect(service.selectedProducts.first?.id == product1.id)
        #expect(service.selectedProducts.first?.quantity == 5)
    }
    
    // MARK: - Helper Methods
    
    private func createTestProduct(id: UUID = UUID(), name: String = "Test Product", quantity: Int = 1) -> Product {
        let category = Category(name: "Food", key: "food")
        let customerType = CustomerType(key: "adult", name: "Adult", isDefault: true)
        let prices: [Currency: Decimal] = [.usd: 10.99, .eur: 9.99, .gbp: 8.99]
        
        return Product(
            id: id,
            name: name,
            prices: prices,
            imageURL: "test-image.jpg",
            category: category,
            quantity: quantity,
            customerType: customerType
        )
    }
}
