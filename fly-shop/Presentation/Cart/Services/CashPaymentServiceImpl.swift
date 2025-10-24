//
//  CashPaymentServiceImpl.swift
//  fly-shop
//
//  Created by Olga Covaliova on 20.10.2025.
//

import Foundation

final class CashPaymentServiceImpl: CashPaymentService {
    
    // MARK: - CashPaymentService Implementation
    
    func validatePaymentAmount(_ amount: String, against total: Decimal) -> Bool {
        guard let decimalAmount = Decimal(string: amount) else { return false }
        return decimalAmount >= total
    }
    
    func processCashPayment(amountPaid: Decimal, totalAmount: Decimal) async throws -> PaymentResult {
        // Validate payment amount
        guard amountPaid >= totalAmount else {
            return PaymentResult.failure(
                error: DomainError.generic,
                message: CartConstants.insufficientPaymentAmountMessage
            )
        }
        
        // Calculate change
        let changeAmount = calculateChange(amountPaid: amountPaid, totalAmount: totalAmount)
        
        // Simulate payment processing delay
        try await Task.sleep(nanoseconds: CartConstants.paymentProcessingDelayNanoseconds)
        
        // Simulate a successful payment
        return PaymentResult.success(
            changeAmount: changeAmount,
            message: CartConstants.paymentProcessedSuccessfullyMessage
        )
    }
    
    func calculateChange(amountPaid: Decimal, totalAmount: Decimal) -> Decimal {
        return CartCalculator.calculateChange(amountPaid: amountPaid, totalAmount: totalAmount)
    }
}
