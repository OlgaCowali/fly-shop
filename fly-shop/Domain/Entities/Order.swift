//
//  Order.swift
//  fly-shop
//
//  Created by Olga Covaliova on 13.10.2025.
//

import Foundation

struct Order: Identifiable, Codable {
    let id: UUID
    let products: [Product]
    let paymentMethod: PaymentMethod
    let totalAmount: Double
    let currency: Currency
    let seatNumber: String
    let orderedAt: Date
    let paidAt: Date
    
    init(
        id: UUID = UUID(),
        products: [Product],
        paymentMethod: PaymentMethod,
        totalAmount: Double,
        currency: Currency,
        seatNumber: String,
        orderedAt: Date,
        paidAt: Date
    ) {
        self.id = id
        self.products = products
        self.paymentMethod = paymentMethod
        self.totalAmount = totalAmount
        self.currency = currency
        self.seatNumber = seatNumber
        self.orderedAt = orderedAt
        self.paidAt = paidAt
    }
}

