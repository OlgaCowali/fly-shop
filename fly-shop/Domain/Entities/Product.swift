//
//  Product.swift
//  fly-shop
//
//  Created by Olga Covaliova on 13.10.2025.
//

import Foundation

struct Product: Identifiable, Codable, Equatable {
    let id: UUID
    let name: String
    let prices: [Currency: Decimal] // ["USD": 29.99, "EUR": 27.99, "GBP": 24.99]
    let imageURL: String
    let category: Category
    var quantity: Int
    let customerType: CustomerType
    var isInCart: Bool = false
    
    init(
        id: UUID = UUID(),
        name: String,
        prices: [Currency: Decimal],
        imageURL: String,
        category: Category,
        quantity: Int = 0,
        customerType: CustomerType
    ) {
        self.id = id
        self.name = name
        self.prices = prices
        self.imageURL = imageURL
        self.category = category
        self.quantity = quantity
        self.customerType = customerType
    }
}

