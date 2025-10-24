//
//  CardPaymentServiceImplTests.swift
//  fly-shop
//
//  Created by Olga Covaliova on 24.10.2025.
//

import Testing
import Foundation
@testable import fly_shop

struct CardPaymentServiceImplTests {
    
    // MARK: - Test Data
    
    private let validCardNumber = "1234567890123456"
    private let validExpirationDate = "12/25"
    private let validCVV = "123"
    private let validCardholderName = "John Doe"
    private let totalAmount: Decimal = 99.99
    private let currency = Currency.usd
    
    private let invalidCardNumber = "123"
    private let invalidExpirationDate = "13/25"
    private let invalidCVV = "12"
    private let invalidCardholderName = ""
    
    // MARK: - Validation Method Tests
    
    @Test("Should validate card number correctly")
    func testValidateCardNumber() {
        // Given
        let mockUseCase = MockProcessPaymentUseCase()
        let service = CardPaymentServiceImpl(processPaymentUseCase: mockUseCase)
        
        // When & Then
        #expect(service.validateCardNumber(validCardNumber) == true)
        #expect(service.validateCardNumber(invalidCardNumber) == false)
    }
    
    @Test("Should validate expiration date correctly")
    func testValidateExpirationDate() {
        // Given
        let mockUseCase = MockProcessPaymentUseCase()
        let service = CardPaymentServiceImpl(processPaymentUseCase: mockUseCase)
        
        // When & Then
        #expect(service.validateExpirationDate(validExpirationDate) == true)
        #expect(service.validateExpirationDate(invalidExpirationDate) == false)
    }
    
    @Test("Should validate CVV correctly")
    func testValidateCVV() {
        // Given
        let mockUseCase = MockProcessPaymentUseCase()
        let service = CardPaymentServiceImpl(processPaymentUseCase: mockUseCase)
        
        // When & Then
        #expect(service.validateCVV(validCVV) == true)
        #expect(service.validateCVV(invalidCVV) == false)
    }
    
    @Test("Should validate cardholder name correctly")
    func testValidateCardholderName() {
        // Given
        let mockUseCase = MockProcessPaymentUseCase()
        let service = CardPaymentServiceImpl(processPaymentUseCase: mockUseCase)
        
        // When & Then
        #expect(service.validateCardholderName(validCardholderName) == true)
        #expect(service.validateCardholderName(invalidCardholderName) == false)
    }
    
    @Test("Should validate all card details correctly")
    func testValidateCardDetails() {
        // Given
        let mockUseCase = MockProcessPaymentUseCase()
        let service = CardPaymentServiceImpl(processPaymentUseCase: mockUseCase)
        
        // When & Then - Valid details
        #expect(service.validateCardDetails(
            cardNumber: validCardNumber,
            expirationDate: validExpirationDate,
            cvv: validCVV,
            cardholderName: validCardholderName
        ) == true)
        
        // When & Then - Invalid card number
        #expect(service.validateCardDetails(
            cardNumber: invalidCardNumber,
            expirationDate: validExpirationDate,
            cvv: validCVV,
            cardholderName: validCardholderName
        ) == false)
        
        // When & Then - Invalid expiration date
        #expect(service.validateCardDetails(
            cardNumber: validCardNumber,
            expirationDate: invalidExpirationDate,
            cvv: validCVV,
            cardholderName: validCardholderName
        ) == false)
        
        // When & Then - Invalid CVV
        #expect(service.validateCardDetails(
            cardNumber: validCardNumber,
            expirationDate: validExpirationDate,
            cvv: invalidCVV,
            cardholderName: validCardholderName
        ) == false)
        
        // When & Then - Invalid cardholder name
        #expect(service.validateCardDetails(
            cardNumber: validCardNumber,
            expirationDate: validExpirationDate,
            cvv: validCVV,
            cardholderName: invalidCardholderName
        ) == false)
    }
    
    // MARK: - Payment Processing Tests
    
    @Test("Should process successful payment")
    func testProcessCardPaymentSuccess() async throws {
        // Given
        let mockUseCase = MockProcessPaymentUseCase()
        mockUseCase.executeResult = .success(PaymentResponseDTO(status: "success", statusCode: 200))
        let service = CardPaymentServiceImpl(processPaymentUseCase: mockUseCase)
        
        // When
        let result = try await service.processCardPayment(
            cardNumber: validCardNumber,
            expirationDate: validExpirationDate,
            cvv: validCVV,
            cardholderName: validCardholderName,
            totalAmount: totalAmount,
            currency: currency
        )
        
        // Then
        #expect(mockUseCase.executeCallCount == 1)
        #expect(result.isSuccess == true)
        #expect(result.changeAmount == 0)
        #expect(result.message != nil)
        #expect(result.error == nil)
    }
    
    @Test("Should handle failed payment response")
    func testProcessCardPaymentFailedResponse() async throws {
        // Given
        let mockUseCase = MockProcessPaymentUseCase()
        mockUseCase.executeResult = .success(PaymentResponseDTO(status: "failed", statusCode: 400))
        let service = CardPaymentServiceImpl(processPaymentUseCase: mockUseCase)
        
        // When
        let result = try await service.processCardPayment(
            cardNumber: validCardNumber,
            expirationDate: validExpirationDate,
            cvv: validCVV,
            cardholderName: validCardholderName,
            totalAmount: totalAmount,
            currency: currency
        )
        
        // Then
        #expect(mockUseCase.executeCallCount == 1)
        #expect(result.isSuccess == false)
        #expect(result.changeAmount == 0)
        #expect(result.message != nil)
        #expect(result.error != nil)
    }
    
    @Test("Should handle network error")
    func testProcessCardPaymentNetworkError() async throws {
        // Given
        let mockUseCase = MockProcessPaymentUseCase()
        mockUseCase.executeResult = .failure(.network)
        let service = CardPaymentServiceImpl(processPaymentUseCase: mockUseCase)
        
        // When
        let result = try await service.processCardPayment(
            cardNumber: validCardNumber,
            expirationDate: validExpirationDate,
            cvv: validCVV,
            cardholderName: validCardholderName,
            totalAmount: totalAmount,
            currency: currency
        )
        
        // Then
        #expect(mockUseCase.executeCallCount == 1)
        #expect(result.isSuccess == false)
        #expect(result.changeAmount == 0)
        #expect(result.message != nil)
        #expect(result.error != nil)
    }
    
    @Test("Should handle server error")
    func testProcessCardPaymentServerError() async throws {
        // Given
        let mockUseCase = MockProcessPaymentUseCase()
        mockUseCase.executeResult = .failure(.server)
        let service = CardPaymentServiceImpl(processPaymentUseCase: mockUseCase)
        
        // When
        let result = try await service.processCardPayment(
            cardNumber: validCardNumber,
            expirationDate: validExpirationDate,
            cvv: validCVV,
            cardholderName: validCardholderName,
            totalAmount: totalAmount,
            currency: currency
        )
        
        // Then
        #expect(mockUseCase.executeCallCount == 1)
        #expect(result.isSuccess == false)
        #expect(result.changeAmount == 0)
        #expect(result.message != nil)
        #expect(result.error != nil)
    }
    
    @Test("Should handle unauthorized error")
    func testProcessCardPaymentUnauthorizedError() async throws {
        // Given
        let mockUseCase = MockProcessPaymentUseCase()
        mockUseCase.executeResult = .failure(.unauthorized)
        let service = CardPaymentServiceImpl(processPaymentUseCase: mockUseCase)
        
        // When
        let result = try await service.processCardPayment(
            cardNumber: validCardNumber,
            expirationDate: validExpirationDate,
            cvv: validCVV,
            cardholderName: validCardholderName,
            totalAmount: totalAmount,
            currency: currency
        )
        
        // Then
        #expect(mockUseCase.executeCallCount == 1)
        #expect(result.isSuccess == false)
        #expect(result.changeAmount == 0)
        #expect(result.message != nil)
        #expect(result.error != nil)
    }
    
    @Test("Should handle invalid card number input")
    func testProcessCardPaymentInvalidCardNumber() async throws {
        // Given
        let mockUseCase = MockProcessPaymentUseCase()
        let service = CardPaymentServiceImpl(processPaymentUseCase: mockUseCase)
        
        // When
        let result = try await service.processCardPayment(
            cardNumber: invalidCardNumber,
            expirationDate: validExpirationDate,
            cvv: validCVV,
            cardholderName: validCardholderName,
            totalAmount: totalAmount,
            currency: currency
        )
        
        // Then
        #expect(mockUseCase.executeCallCount == 0)
        #expect(result.isSuccess == false)
        #expect(result.changeAmount == 0)
        #expect(result.message != nil)
        #expect(result.error != nil)
    }
    
    @Test("Should handle invalid expiration date input")
    func testProcessCardPaymentInvalidExpirationDate() async throws {
        // Given
        let mockUseCase = MockProcessPaymentUseCase()
        let service = CardPaymentServiceImpl(processPaymentUseCase: mockUseCase)
        
        // When
        let result = try await service.processCardPayment(
            cardNumber: validCardNumber,
            expirationDate: invalidExpirationDate,
            cvv: validCVV,
            cardholderName: validCardholderName,
            totalAmount: totalAmount,
            currency: currency
        )
        
        // Then
        #expect(mockUseCase.executeCallCount == 0)
        #expect(result.isSuccess == false)
        #expect(result.changeAmount == 0)
        #expect(result.message != nil)
        #expect(result.error != nil)
    }
    
    @Test("Should handle invalid CVV input")
    func testProcessCardPaymentInvalidCVV() async throws {
        // Given
        let mockUseCase = MockProcessPaymentUseCase()
        let service = CardPaymentServiceImpl(processPaymentUseCase: mockUseCase)
        
        // When
        let result = try await service.processCardPayment(
            cardNumber: validCardNumber,
            expirationDate: validExpirationDate,
            cvv: invalidCVV,
            cardholderName: validCardholderName,
            totalAmount: totalAmount,
            currency: currency
        )
        
        // Then
        #expect(mockUseCase.executeCallCount == 0)
        #expect(result.isSuccess == false)
        #expect(result.changeAmount == 0)
        #expect(result.message != nil)
        #expect(result.error != nil)
    }
    
    @Test("Should handle invalid cardholder name input")
    func testProcessCardPaymentInvalidCardholderName() async throws {
        // Given
        let mockUseCase = MockProcessPaymentUseCase()
        let service = CardPaymentServiceImpl(processPaymentUseCase: mockUseCase)
        
        // When
        let result = try await service.processCardPayment(
            cardNumber: validCardNumber,
            expirationDate: validExpirationDate,
            cvv: validCVV,
            cardholderName: invalidCardholderName,
            totalAmount: totalAmount,
            currency: currency
        )
        
        // Then
        #expect(mockUseCase.executeCallCount == 0)
        #expect(result.isSuccess == false)
        #expect(result.changeAmount == 0)
        #expect(result.message != nil)
        #expect(result.error != nil)
    }
}

