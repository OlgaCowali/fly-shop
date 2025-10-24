//
//  CashPaymentService.swift
//  fly-shop
//
//  Created by Olga Covaliova on 20.10.2025.
//

import Foundation

// MARK: - Payment Result

struct PaymentResult {
    let isSuccess: Bool
    let changeAmount: Decimal
    let message: String?
    let error: Error?
    
    static func success(changeAmount: Decimal, message: String? = nil) -> PaymentResult {
        PaymentResult(isSuccess: true, changeAmount: changeAmount, message: message, error: nil)
    }
    
    static func failure(error: Error, message: String? = nil) -> PaymentResult {
        PaymentResult(isSuccess: false, changeAmount: 0, message: message, error: error)
    }
}

// MARK: - Cash Payment Service Protocol

protocol CashPaymentService {
    // Validates if the entered amount is sufficient for the total payment
    func validatePaymentAmount(_ amount: String, against total: Decimal) -> Bool
    
    // Processes a cash payment and returns the result
    func processCashPayment(amountPaid: Decimal, totalAmount: Decimal) async throws -> PaymentResult
    
    // Calculates the change amount for a given payment
    func calculateChange(amountPaid: Decimal, totalAmount: Decimal) -> Decimal
}
