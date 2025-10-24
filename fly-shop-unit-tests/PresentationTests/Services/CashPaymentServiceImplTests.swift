//
//  CashPaymentServiceImplTests.swift
//  fly-shop
//
//  Created by Olga Covaliova on 24.10.2025.
//

import Testing
import Foundation
@testable import fly_shop

struct CashPaymentServiceImplTests {
    
    private let service = CashPaymentServiceImpl()
    
    // MARK: - validatePaymentAmount Tests
    
    @Test("validatePaymentAmount - valid amount greater than total")
    func validatePaymentAmountValidGreater() {
        let amount = "100.50"
        let total = Decimal(50.25)
        
        let result = service.validatePaymentAmount(amount, against: total)
        
        #expect(result == true)
    }
    
    @Test("validatePaymentAmount - valid amount equal to total")
    func validatePaymentAmountValidEqual() {
        let amount = "50.25"
        let total = Decimal(50.25)
        
        let result = service.validatePaymentAmount(amount, against: total)
        
        #expect(result == true)
    }
    
    @Test("validatePaymentAmount - valid amount less than total")
    func validatePaymentAmountValidLess() {
        let amount = "25.00"
        let total = Decimal(50.25)
        
        let result = service.validatePaymentAmount(amount, against: total)
        
        #expect(result == false)
    }
    
    @Test("validatePaymentAmount - invalid amount string")
    func validatePaymentAmountInvalidString() {
        let amount = "invalid"
        let total = Decimal(50.25)
        
        let result = service.validatePaymentAmount(amount, against: total)
        
        #expect(result == false)
    }
    
    @Test("validatePaymentAmount - empty string")
    func validatePaymentAmountEmptyString() {
        let amount = ""
        let total = Decimal(50.25)
        
        let result = service.validatePaymentAmount(amount, against: total)
        
        #expect(result == false)
    }
    
    // MARK: - processCashPayment Tests
    
    @Test("processCashPayment - successful payment")
    func processCashPaymentSuccess() async throws {
        let amountPaid = Decimal(100.00)
        let totalAmount = Decimal(75.50)
        
        let result = try await service.processCashPayment(amountPaid: amountPaid, totalAmount: totalAmount)
        
        #expect(result.isSuccess == true)
        #expect(result.changeAmount == Decimal(24.50))
        #expect(result.message == CartConstants.paymentProcessedSuccessfullyMessage)
        #expect(result.error == nil)
    }
    
    @Test("processCashPayment - insufficient payment amount")
    func processCashPaymentInsufficient() async throws {
        let amountPaid = Decimal(25.00)
        let totalAmount = Decimal(50.25)
        
        let result = try await service.processCashPayment(amountPaid: amountPaid, totalAmount: totalAmount)
        
        #expect(result.isSuccess == false)
        #expect(result.changeAmount == Decimal(0))
        #expect(result.message == CartConstants.insufficientPaymentAmountMessage)
        #expect(result.error as! DomainError == DomainError.generic)
    }
    
    @Test("processCashPayment - exact payment amount")
    func processCashPaymentExact() async throws {
        let amountPaid = Decimal(50.25)
        let totalAmount = Decimal(50.25)
        
        let result = try await service.processCashPayment(amountPaid: amountPaid, totalAmount: totalAmount)
        
        #expect(result.isSuccess == true)
        #expect(result.changeAmount == Decimal(0))
        #expect(result.message == CartConstants.paymentProcessedSuccessfullyMessage)
        #expect(result.error == nil)
    }
}
