//
//  MockCashPaymentService.swift
//  fly-shop-unit-tests
//
//  Created by Olga Covaliova on 23.10.2025.
//

import Foundation
@testable import fly_shop

final class MockCashPaymentService: CashPaymentService {
    
    // MARK: - Call Tracking
    
    var validatePaymentAmountCallCount = 0
    var validatePaymentAmountCalledWithAmount: String?
    var validatePaymentAmountCalledWithTotal: Decimal?
    var validatePaymentAmountReturnValue = true
    
    var processCashPaymentCallCount = 0
    var processCashPaymentCalledWithAmountPaid: Decimal?
    var processCashPaymentCalledWithTotalAmount: Decimal?
    var processCashPaymentReturnValue: PaymentResult?
    var processCashPaymentShouldThrow = false
    
    var calculateChangeCallCount = 0
    var calculateChangeCalledWithAmountPaid: Decimal?
    var calculateChangeCalledWithTotalAmount: Decimal?
    var calculateChangeReturnValue: Decimal = 0.0
    
    // MARK: - Initialization
    
    init() {}
    
    // MARK: - CashPaymentService Implementation
    
    func validatePaymentAmount(_ amount: String, against total: Decimal) -> Bool {
        validatePaymentAmountCallCount += 1
        validatePaymentAmountCalledWithAmount = amount
        validatePaymentAmountCalledWithTotal = total
        return validatePaymentAmountReturnValue
    }
    
    func processCashPayment(amountPaid: Decimal, totalAmount: Decimal) async throws -> PaymentResult {
        processCashPaymentCallCount += 1
        processCashPaymentCalledWithAmountPaid = amountPaid
        processCashPaymentCalledWithTotalAmount = totalAmount
        
        if processCashPaymentShouldThrow {
            throw DomainError.generic
        }
        
        return processCashPaymentReturnValue ?? PaymentResult.success(
            changeAmount: 0,
            message: "Payment processed successfully"
        )
    }
    
    func calculateChange(amountPaid: Decimal, totalAmount: Decimal) -> Decimal {
        calculateChangeCallCount += 1
        calculateChangeCalledWithAmountPaid = amountPaid
        calculateChangeCalledWithTotalAmount = totalAmount
        return calculateChangeReturnValue
    }
    
    // MARK: - Helper Methods
    
    func reset() {
        validatePaymentAmountCallCount = 0
        validatePaymentAmountCalledWithAmount = nil
        validatePaymentAmountCalledWithTotal = nil
        validatePaymentAmountReturnValue = true
        
        processCashPaymentCallCount = 0
        processCashPaymentCalledWithAmountPaid = nil
        processCashPaymentCalledWithTotalAmount = nil
        processCashPaymentReturnValue = nil
        processCashPaymentShouldThrow = false
        
        calculateChangeCallCount = 0
        calculateChangeCalledWithAmountPaid = nil
        calculateChangeCalledWithTotalAmount = nil
        calculateChangeReturnValue = 0.0
    }
}
