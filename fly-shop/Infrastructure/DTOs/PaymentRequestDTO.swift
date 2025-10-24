//
//  PaymentRequestDTO.swift
//  fly-shop
//
//  Created by Olga Covaliova on 24.10.2025.
//

import Foundation

struct PaymentRequestDTO: Codable {
    let cardNumber: String
    let expirationDate: String
    let cvv: String
    let cardholderName: String
    let amount: Decimal
    let currency: String
    
    enum CodingKeys: String, CodingKey {
        case cardNumber = "card_number"
        case expirationDate = "expiration_date"
        case cvv
        case cardholderName = "cardholder_name"
        case amount
        case currency
    }
    
    // Convenience initializer to create DTO from domain Payment entity
    init(from payment: Payment) {
        self.cardNumber = payment.cardNumber.value
        self.expirationDate = payment.expirationDate.value
        self.cvv = payment.cvv.value
        self.cardholderName = payment.cardholderName.value
        self.amount = payment.amount
        self.currency = payment.currency.rawValue
    }
}

