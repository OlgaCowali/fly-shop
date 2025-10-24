//
//  MockCardPaymentService.swift
//  fly-shop-unit-tests
//
//  Created by Olga Covaliova on 23.10.2025.
//

import Foundation
@testable import fly_shop

final class MockCardPaymentService: CardPaymentService {
    
    // MARK: - Call Tracking
    
    var processCardPaymentCallCount = 0
    var processCardPaymentCalledWithCardNumber: String?
    var processCardPaymentCalledWithExpirationDate: String?
    var processCardPaymentCalledWithCVV: String?
    var processCardPaymentCalledWithCardholderName: String?
    var processCardPaymentCalledWithTotalAmount: Decimal?
    var processCardPaymentCalledWithCurrency: Currency?
    var processCardPaymentReturnValue: PaymentResult?
    var processCardPaymentShouldThrow = false
    
    var validateCardNumberCallCount = 0
    var validateCardNumberCalledWithCardNumber: String?
    var validateCardNumberReturnValue = true
    
    var validateExpirationDateCallCount = 0
    var validateExpirationDateCalledWithExpirationDate: String?
    var validateExpirationDateReturnValue = true
    
    var validateCVVCallCount = 0
    var validateCVVCalledWithCVV: String?
    var validateCVVReturnValue = true
    
    var validateCardholderNameCallCount = 0
    var validateCardholderNameCalledWithName: String?
    var validateCardholderNameReturnValue = true
    
    // MARK: - Initialization
    
    init() {}
    
    // MARK: - CardPaymentService Implementation
    
    func validateCardDetails(
        cardNumber: String,
        expirationDate: String,
        cvv: String,
        cardholderName: String
    ) -> Bool {
        return validateCardNumber(cardNumber) &&
               validateExpirationDate(expirationDate) &&
               validateCVV(cvv) &&
               validateCardholderName(cardholderName)
    }
    
    func processCardPayment(
        cardNumber: String,
        expirationDate: String,
        cvv: String,
        cardholderName: String,
        totalAmount: Decimal,
        currency: Currency
    ) async throws -> PaymentResult {
        processCardPaymentCallCount += 1
        processCardPaymentCalledWithCardNumber = cardNumber
        processCardPaymentCalledWithExpirationDate = expirationDate
        processCardPaymentCalledWithCVV = cvv
        processCardPaymentCalledWithCardholderName = cardholderName
        processCardPaymentCalledWithTotalAmount = totalAmount
        processCardPaymentCalledWithCurrency = currency
        
        if processCardPaymentShouldThrow {
            throw DomainError.generic
        }
        
        return processCardPaymentReturnValue ?? PaymentResult.success(
            changeAmount: 0,
            message: "Payment processed successfully"
        )
    }
    
    func validateCardNumber(_ cardNumber: String) -> Bool {
        validateCardNumberCallCount += 1
        validateCardNumberCalledWithCardNumber = cardNumber
        return validateCardNumberReturnValue
    }
    
    func validateExpirationDate(_ expirationDate: String) -> Bool {
        validateExpirationDateCallCount += 1
        validateExpirationDateCalledWithExpirationDate = expirationDate
        return validateExpirationDateReturnValue
    }
    
    func validateCVV(_ cvv: String) -> Bool {
        validateCVVCallCount += 1
        validateCVVCalledWithCVV = cvv
        return validateCVVReturnValue
    }
    
    func validateCardholderName(_ name: String) -> Bool {
        validateCardholderNameCallCount += 1
        validateCardholderNameCalledWithName = name
        return validateCardholderNameReturnValue
    }
    
    // MARK: - Helper Methods
    
    func reset() {
        processCardPaymentCallCount = 0
        processCardPaymentCalledWithCardNumber = nil
        processCardPaymentCalledWithExpirationDate = nil
        processCardPaymentCalledWithCVV = nil
        processCardPaymentCalledWithCardholderName = nil
        processCardPaymentCalledWithTotalAmount = nil
        processCardPaymentCalledWithCurrency = nil
        processCardPaymentReturnValue = nil
        processCardPaymentShouldThrow = false
        
        validateCardNumberCallCount = 0
        validateCardNumberCalledWithCardNumber = nil
        validateCardNumberReturnValue = true
        
        validateExpirationDateCallCount = 0
        validateExpirationDateCalledWithExpirationDate = nil
        validateExpirationDateReturnValue = true
        
        validateCVVCallCount = 0
        validateCVVCalledWithCVV = nil
        validateCVVReturnValue = true
        
        validateCardholderNameCallCount = 0
        validateCardholderNameCalledWithName = nil
        validateCardholderNameReturnValue = true
    }
}
