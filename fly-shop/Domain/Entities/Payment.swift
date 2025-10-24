//
//  Payment.swift
//  fly-shop
//
//  Created by Olga Covaliova on 24.10.2025.
//

import Foundation

struct Payment {
    let cardNumber: CardNumber
    let expirationDate: ExpirationDate
    let cvv: CVV
    let cardholderName: CardholderName
    let amount: Decimal
    let currency: Currency
    
    init(
        cardNumber: CardNumber,
        expirationDate: ExpirationDate,
        cvv: CVV,
        cardholderName: CardholderName,
        amount: Decimal,
        currency: Currency
    ) {
        self.cardNumber = cardNumber
        self.expirationDate = expirationDate
        self.cvv = cvv
        self.cardholderName = cardholderName
        self.amount = amount
        self.currency = currency
    }
}

