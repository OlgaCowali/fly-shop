//
//  CardPaymentViewModelTests.swift
//  fly-shop
//
//  Created by Olga Covaliova on 24.10.2025.
//

import Testing
import Foundation
@testable import fly_shop

struct CardPaymentViewModelTests {
    
    // MARK: - Test Data
    
    private let sampleTotalAmount: Decimal = 99.99
    private let sampleCurrency: Currency = .usd
    private let sampleCardNumber = "1234567890123456"
    private let sampleExpirationDate = "12/25"
    private let sampleCVV = "123"
    private let sampleCardholderName = "John Doe"
    
    // MARK: - Initialization Tests
    
    @MainActor @Test("Should initialize with correct properties")
    func testInitialization() {
        // Given
        let mockService = MockCardPaymentService()
        
        // When
        let viewModel = CardPaymentViewModel(
            paymentService: mockService,
            totalAmount: sampleTotalAmount,
            currency: sampleCurrency
        )
        
        // Then
        #expect(viewModel.cardNumber.isEmpty)
        #expect(viewModel.expirationDate.isEmpty)
        #expect(viewModel.cvv.isEmpty)
        #expect(viewModel.cardholderName.isEmpty)
        #expect(viewModel.isProcessing == false)
        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.currency == sampleCurrency)
    }
    
    // MARK: - Form Validation Tests
    
    @MainActor @Test("Should validate expiration date correctly")
    func testValidateExpirationDate() {
        // Given
        let mockService = MockCardPaymentService()
        let viewModel = CardPaymentViewModel(
            paymentService: mockService,
            totalAmount: sampleTotalAmount,
            currency: sampleCurrency
        )
        
        // When
        viewModel.validateExpirationDate(sampleExpirationDate)
        
        // Then
        #expect(viewModel.expirationDate == sampleExpirationDate)
        #expect(viewModel.errorMessage == nil)
    }
    
    @MainActor @Test("Should validate CVV correctly")
    func testValidateCVV() {
        // Given
        let mockService = MockCardPaymentService()
        let viewModel = CardPaymentViewModel(
            paymentService: mockService,
            totalAmount: sampleTotalAmount,
            currency: sampleCurrency
        )
        
        // When
        viewModel.validateCVV(sampleCVV)
        
        // Then
        #expect(viewModel.cvv == sampleCVV)
        #expect(viewModel.errorMessage == nil)
    }
    
    @MainActor @Test("Should validate cardholder name correctly")
    func testValidateCardholderName() {
        // Given
        let mockService = MockCardPaymentService()
        let viewModel = CardPaymentViewModel(
            paymentService: mockService,
            totalAmount: sampleTotalAmount,
            currency: sampleCurrency
        )
        
        // When
        viewModel.validateCardholderName(sampleCardholderName)
        
        // Then
        #expect(viewModel.cardholderName == sampleCardholderName)
        #expect(viewModel.errorMessage == nil)
    }
    
    @MainActor @Test("Should return true for valid form when all fields are filled correctly")
    func testIsFormValidWithValidFields() {
        // Given
        let mockService = MockCardPaymentService()
        let viewModel = CardPaymentViewModel(
            paymentService: mockService,
            totalAmount: sampleTotalAmount,
            currency: sampleCurrency
        )
        
        // When
        viewModel.cardNumber = sampleCardNumber
        viewModel.expirationDate = sampleExpirationDate
        viewModel.cvv = sampleCVV
        viewModel.cardholderName = sampleCardholderName
        
        // Then
        #expect(viewModel.isFormValid == true)
    }
    
    @MainActor @Test("Should return false for invalid form when card number is too short")
    func testIsFormValidWithShortCardNumber() {
        // Given
        let mockService = MockCardPaymentService()
        let viewModel = CardPaymentViewModel(
            paymentService: mockService,
            totalAmount: sampleTotalAmount,
            currency: sampleCurrency
        )
        
        // When
        viewModel.cardNumber = "123456789012345" // 15 digits
        viewModel.expirationDate = sampleExpirationDate
        viewModel.cvv = sampleCVV
        viewModel.cardholderName = sampleCardholderName
        
        // Then
        #expect(viewModel.isFormValid == false)
    }
    
    @MainActor @Test("Should return false for invalid form when expiration date is wrong format")
    func testIsFormValidWithWrongExpirationDate() {
        // Given
        let mockService = MockCardPaymentService()
        let viewModel = CardPaymentViewModel(
            paymentService: mockService,
            totalAmount: sampleTotalAmount,
            currency: sampleCurrency
        )
        
        // When
        viewModel.cardNumber = sampleCardNumber
        viewModel.expirationDate = "12/2" // Wrong format
        viewModel.cvv = sampleCVV
        viewModel.cardholderName = sampleCardholderName
        
        // Then
        #expect(viewModel.isFormValid == false)
    }
    
    @MainActor @Test("Should return false for invalid form when CVV is too short")
    func testIsFormValidWithShortCVV() {
        // Given
        let mockService = MockCardPaymentService()
        let viewModel = CardPaymentViewModel(
            paymentService: mockService,
            totalAmount: sampleTotalAmount,
            currency: sampleCurrency
        )
        
        // When
        viewModel.cardNumber = sampleCardNumber
        viewModel.expirationDate = sampleExpirationDate
        viewModel.cvv = "12" // Too short
        viewModel.cardholderName = sampleCardholderName
        
        // Then
        #expect(viewModel.isFormValid == false)
    }
    
    @MainActor @Test("Should return false for invalid form when cardholder name contains numbers")
    func testIsFormValidWithInvalidCardholderName() {
        // Given
        let mockService = MockCardPaymentService()
        let viewModel = CardPaymentViewModel(
            paymentService: mockService,
            totalAmount: sampleTotalAmount,
            currency: sampleCurrency
        )
        
        // When
        viewModel.cardNumber = sampleCardNumber
        viewModel.expirationDate = sampleExpirationDate
        viewModel.cvv = sampleCVV
        viewModel.cardholderName = "John123" // Contains numbers
        
        // Then
        #expect(viewModel.isFormValid == false)
    }
    
    @MainActor @Test("Should return true for valid cardholder name with spaces")
    func testIsCardholderNameValidWithSpaces() {
        // Given
        let mockService = MockCardPaymentService()
        let viewModel = CardPaymentViewModel(
            paymentService: mockService,
            totalAmount: sampleTotalAmount,
            currency: sampleCurrency
        )
        
        // When
        viewModel.cardholderName = "John Michael Doe"
        
        // Then
        #expect(viewModel.isCardholderNameValid == true)
    }
    
    // MARK: - Payment Processing Success Tests
    
    @MainActor @Test("Should process payment successfully")
    func testProcessPaymentSuccess() async {
        // Given
        let mockService = MockCardPaymentService()
        mockService.processCardPaymentReturnValue = PaymentResult.success(
            changeAmount: 0,
            message: "Payment successful"
        )
        let viewModel = CardPaymentViewModel(
            paymentService: mockService,
            totalAmount: sampleTotalAmount,
            currency: sampleCurrency
        )
        
        // Set valid form data
        viewModel.cardNumber = sampleCardNumber
        viewModel.expirationDate = sampleExpirationDate
        viewModel.cvv = sampleCVV
        viewModel.cardholderName = sampleCardholderName
        
        // When
        let result = await viewModel.processPayment()
        
        // Then
        #expect(mockService.processCardPaymentCallCount == 1)
        #expect(mockService.processCardPaymentCalledWithCardNumber == sampleCardNumber)
        #expect(mockService.processCardPaymentCalledWithExpirationDate == sampleExpirationDate)
        #expect(mockService.processCardPaymentCalledWithCVV == sampleCVV)
        #expect(mockService.processCardPaymentCalledWithCardholderName == sampleCardholderName)
        #expect(mockService.processCardPaymentCalledWithTotalAmount == sampleTotalAmount)
        #expect(mockService.processCardPaymentCalledWithCurrency == sampleCurrency)
        #expect(result.isSuccess == true)
        #expect(viewModel.isProcessing == false)
        #expect(viewModel.errorMessage == nil)
    }
    
    // MARK: - Payment Processing Failure Tests
    
    @MainActor @Test("Should return failure when form is invalid")
    func testProcessPaymentWithInvalidForm() async {
        // Given
        let mockService = MockCardPaymentService()
        let viewModel = CardPaymentViewModel(
            paymentService: mockService,
            totalAmount: sampleTotalAmount,
            currency: sampleCurrency
        )
        
        // Leave form invalid (empty fields)
        
        // When
        let result = await viewModel.processPayment()
        
        // Then
        #expect(mockService.processCardPaymentCallCount == 0)
        #expect(result.isSuccess == false)
        #expect(viewModel.isProcessing == false)
    }
    
    @MainActor @Test("Should handle payment service failure")
    func testProcessPaymentServiceFailure() async {
        // Given
        let mockService = MockCardPaymentService()
        mockService.processCardPaymentReturnValue = PaymentResult.failure(
            error: DomainError.generic,
            message: "Payment failed"
        )
        let viewModel = CardPaymentViewModel(
            paymentService: mockService,
            totalAmount: sampleTotalAmount,
            currency: sampleCurrency
        )
        
        // Set valid form data
        viewModel.cardNumber = sampleCardNumber
        viewModel.expirationDate = sampleExpirationDate
        viewModel.cvv = sampleCVV
        viewModel.cardholderName = sampleCardholderName
        
        // When
        let result = await viewModel.processPayment()
        
        // Then
        #expect(result.isSuccess == false)
        #expect(viewModel.isProcessing == false)
        #expect(viewModel.errorMessage == "Payment failed")
    }
    
    @MainActor @Test("Should handle payment service exception")
    func testProcessPaymentServiceException() async {
        // Given
        let mockService = MockCardPaymentService()
        mockService.processCardPaymentShouldThrow = true
        let viewModel = CardPaymentViewModel(
            paymentService: mockService,
            totalAmount: sampleTotalAmount,
            currency: sampleCurrency
        )
        
        // Set valid form data
        viewModel.cardNumber = sampleCardNumber
        viewModel.expirationDate = sampleExpirationDate
        viewModel.cvv = sampleCVV
        viewModel.cardholderName = sampleCardholderName
        
        // When
        let result = await viewModel.processPayment()
        
        // Then
        #expect(result.isSuccess == false)
        #expect(viewModel.isProcessing == false)
        #expect(viewModel.errorMessage != nil)
    }
    
    // MARK: - Error Handling Tests
    
    @MainActor @Test("Should clear error when validating fields")
    func testClearErrorOnValidation() {
        // Given
        let mockService = MockCardPaymentService()
        let viewModel = CardPaymentViewModel(
            paymentService: mockService,
            totalAmount: sampleTotalAmount,
            currency: sampleCurrency
        )
        
        // Set an error first
        viewModel.errorMessage = "Some error"
        
        // When
        viewModel.validateCardNumber(sampleCardNumber)
        
        // Then
        #expect(viewModel.errorMessage == nil)
    }
    
    @MainActor @Test("Should clear error explicitly")
    func testClearErrorExplicitly() {
        // Given
        let mockService = MockCardPaymentService()
        let viewModel = CardPaymentViewModel(
            paymentService: mockService,
            totalAmount: sampleTotalAmount,
            currency: sampleCurrency
        )
        
        // Set an error first
        viewModel.errorMessage = "Some error"
        
        // When
        viewModel.clearError()
        
        // Then
        #expect(viewModel.errorMessage == nil)
    }
    
    // MARK: - Integration Tests
    
    @MainActor @Test("Should call payment service with correct parameters")
    func testPaymentServiceCalledWithCorrectParameters() async {
        // Given
        let mockService = MockCardPaymentService()
        mockService.processCardPaymentReturnValue = PaymentResult.success(
            changeAmount: 0,
            message: "Success"
        )
        let viewModel = CardPaymentViewModel(
            paymentService: mockService,
            totalAmount: sampleTotalAmount,
            currency: sampleCurrency
        )
        
        // Set valid form data
        viewModel.cardNumber = sampleCardNumber
        viewModel.expirationDate = sampleExpirationDate
        viewModel.cvv = sampleCVV
        viewModel.cardholderName = sampleCardholderName
        
        // When
        _ = await viewModel.processPayment()
        
        // Then
        #expect(mockService.processCardPaymentCallCount == 1)
        #expect(mockService.processCardPaymentCalledWithCardNumber == sampleCardNumber)
        #expect(mockService.processCardPaymentCalledWithExpirationDate == sampleExpirationDate)
        #expect(mockService.processCardPaymentCalledWithCVV == sampleCVV)
        #expect(mockService.processCardPaymentCalledWithCardholderName == sampleCardholderName)
        #expect(mockService.processCardPaymentCalledWithTotalAmount == sampleTotalAmount)
        #expect(mockService.processCardPaymentCalledWithCurrency == sampleCurrency)
    }
    
    @MainActor @Test("Should not call payment service when form is invalid")
    func testPaymentServiceNotCalledWithInvalidForm() async {
        // Given
        let mockService = MockCardPaymentService()
        let viewModel = CardPaymentViewModel(
            paymentService: mockService,
            totalAmount: sampleTotalAmount,
            currency: sampleCurrency
        )
        
        // Leave form invalid
        
        // When
        _ = await viewModel.processPayment()
        
        // Then
        #expect(mockService.processCardPaymentCallCount == 0)
    }
}
