//
//  CardPaymentService.swift
//  fly-shop
//
//  Created by Olga Covaliova on 20.10.2025.
//

import Foundation

// MARK: - Card Payment Service Protocol

protocol CardPaymentService {
    // Validates card details (number, expiration, CVV, cardholder name)
    func validateCardDetails(
        cardNumber: String,
        expirationDate: String,
        cvv: String,
        cardholderName: String
    ) -> Bool
    
    // Processes a card payment and returns the result
    func processCardPayment(
        cardNumber: String,
        expirationDate: String,
        cvv: String,
        cardholderName: String,
        totalAmount: Decimal,
        currency: Currency
    ) async throws -> PaymentResult
    
    // Validates card number format (Luhn algorithm)
    func validateCardNumber(_ cardNumber: String) -> Bool
    
    // Validates expiration date format and future date
    func validateExpirationDate(_ expirationDate: String) -> Bool
    
    // Validates CVV format
    func validateCVV(_ cvv: String) -> Bool
    
    // Validates cardholder name format
    func validateCardholderName(_ name: String) -> Bool
}
