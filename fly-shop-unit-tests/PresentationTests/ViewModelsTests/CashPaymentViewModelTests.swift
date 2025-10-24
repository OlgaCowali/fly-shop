//
//  CashPaymentViewModelTests.swift
//  fly-shop
//
//  Created by Olga Covaliova on 24.10.2025.
//

import Testing
import Foundation
@testable import fly_shop

@MainActor
struct CashPaymentViewModelTests {
    
    // MARK: - Test Properties
    
    private let mockPaymentService = MockCashPaymentService()
    private let testTotalAmount: Decimal = 25.50
    private let testCurrency: Currency = .usd
    
    // MARK: - Helper Methods
    
    private func createViewModel() -> CashPaymentViewModel {
        return CashPaymentViewModel(
            paymentService: mockPaymentService,
            totalAmount: testTotalAmount,
            currency: testCurrency
        )
    }
    
    // MARK: - Computed Properties Tests
    
    @Test("Change amount calculation")
    func testChangeAmountCalculation() {
        let viewModel = createViewModel()
        mockPaymentService.calculateChangeReturnValue = 5.25
        
        viewModel.enteredAmount = "30.75"
        
        #expect(viewModel.changeAmount == 5.25)
        #expect(mockPaymentService.calculateChangeCallCount == 1)
        #expect(mockPaymentService.calculateChangeCalledWithAmountPaid == 30.75)
        #expect(mockPaymentService.calculateChangeCalledWithTotalAmount == testTotalAmount)
    }
    
    @Test("Change amount with invalid input")
    func testChangeAmountWithInvalidInput() {
        let viewModel = createViewModel()
        
        viewModel.enteredAmount = "invalid"
        
        #expect(viewModel.changeAmount == 0)
    }
    
    // MARK: - Validation Tests
    
    @Test("Valid amount validation")
    func testValidAmountValidation() {
        let viewModel = createViewModel()
        mockPaymentService.validatePaymentAmountReturnValue = true
        
        viewModel.validateAmount("30.00")
        
        #expect(viewModel.enteredAmount == "30.00")
        #expect(viewModel.isValidAmount == true)
        #expect(viewModel.errorMessage == nil)
        #expect(mockPaymentService.validatePaymentAmountCallCount == 1)
        #expect(mockPaymentService.validatePaymentAmountCalledWithAmount == "30.00")
        #expect(mockPaymentService.validatePaymentAmountCalledWithTotal == testTotalAmount)
    }
    
    @Test("Invalid amount validation")
    func testInvalidAmountValidation() {
        let viewModel = createViewModel()
        mockPaymentService.validatePaymentAmountReturnValue = false
        
        viewModel.validateAmount("20.00")
        
        #expect(viewModel.enteredAmount == "20.00")
        #expect(viewModel.isValidAmount == false)
        #expect(viewModel.errorMessage == nil)
    }
    
    // MARK: - Payment Processing Tests
    
    @Test("Successful payment processing")
    func testSuccessfulPaymentProcessing() async {
        let viewModel = createViewModel()
        let expectedResult = PaymentResult.success(changeAmount: 5.25, message: "Payment successful")
        mockPaymentService.processCashPaymentReturnValue = expectedResult
        mockPaymentService.validatePaymentAmountReturnValue = true
        
        viewModel.validateAmount("30.75") // This sets both enteredAmount and isValidAmount
        
        let result = await viewModel.processPayment()
        
        #expect(result.isSuccess == true)
        #expect(result.changeAmount == 5.25)
        #expect(viewModel.isProcessing == false)
        #expect(viewModel.errorMessage == nil)
        #expect(mockPaymentService.processCashPaymentCallCount == 1)
        #expect(mockPaymentService.processCashPaymentCalledWithAmountPaid == 30.75)
        #expect(mockPaymentService.processCashPaymentCalledWithTotalAmount == testTotalAmount)
    }
    
    @Test("Payment processing with error")
    func testPaymentProcessingWithError() async {
        let viewModel = createViewModel()
        mockPaymentService.processCashPaymentShouldThrow = true
        mockPaymentService.validatePaymentAmountReturnValue = true
        
        viewModel.validateAmount("30.75") // This sets both enteredAmount and isValidAmount
        
        let result = await viewModel.processPayment()
        
        #expect(result.isSuccess == false)
        #expect(viewModel.isProcessing == false)
        #expect(viewModel.errorMessage != nil)
        #expect(viewModel.errorMessage?.contains("Payment processing failed") == true)
    }
    
    @Test("Payment processing with insufficient amount")
    func testPaymentProcessingWithInsufficientAmount() async {
        let viewModel = createViewModel()
        mockPaymentService.validatePaymentAmountReturnValue = false
        
        viewModel.enteredAmount = "20.00"
        viewModel.validateAmount("20.00") // This sets isValidAmount to false
        
        let result = await viewModel.processPayment()
        
        #expect(result.isSuccess == false)
        #expect(result.message?.contains("Invalid payment amount") == true)
    }

    
    // MARK: - Error Handling Tests
    
    @Test("Clear error functionality")
    func testClearError() {
        let viewModel = createViewModel()
        viewModel.errorMessage = "Test error"
        
        viewModel.clearError()
        
        #expect(viewModel.errorMessage == nil)
    }
    
    @Test("Error cleared on validation")
    func testErrorClearedOnValidation() {
        let viewModel = createViewModel()
        viewModel.errorMessage = "Test error"
        
        viewModel.validateAmount("30.00")
        
        #expect(viewModel.errorMessage == nil)
    }
}
