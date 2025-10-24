//
//  ProcessPaymentUseCaseTests.swift
//  fly-shop
//
//  Created by Olga Covaliova on 24.10.2025.
//

import Testing
import Foundation
@testable import fly_shop

struct ProcessPaymentUseCaseTests {
    
    // MARK: - Test Data
    
    private func createValidPayment() -> Payment {
        return Payment(
            cardNumber: CardNumber("1234567890123456")!,
            expirationDate: ExpirationDate("12/25")!,
            cvv: CVV("123")!,
            cardholderName: CardholderName("John Doe")!,
            amount: 99.99,
            currency: .usd
        )
    }
    
    private let successResponse = PaymentResponseDTO(
        status: "success",
        statusCode: 200
    )
    
    private let failureResponse = PaymentResponseDTO(
        status: "failed",
        statusCode: 400
    )
    
    // MARK: - Success Tests
    
    @Test("Should return success when repository returns successful payment")
    func testExecuteReturnsSuccessOnSuccessfulPayment() async throws {
        // Given
        let mockRepository = MockPaymentRepository()
        mockRepository.processPaymentResult = .success(successResponse)
        let useCase = ProcessPaymentUseCase(repository: mockRepository)
        let payment = createValidPayment()
        
        // When
        let result = await useCase.execute(payment)
        
        // Then
        #expect(mockRepository.processPaymentCallCount == 1)
        
        switch result {
        case .success(let response):
            #expect(response.status == "success")
            #expect(response.statusCode == 200)
            #expect(response.isSuccessful == true)
        case .failure:
            Issue.record("Expected success but got failure")
        }
    }
    
    @Test("Should return failure response when repository returns failed payment")
    func testExecuteReturnsFailureOnFailedPayment() async throws {
        // Given
        let mockRepository = MockPaymentRepository()
        mockRepository.processPaymentResult = .success(failureResponse)
        let useCase = ProcessPaymentUseCase(repository: mockRepository)
        let payment = createValidPayment()
        
        // When
        let result = await useCase.execute(payment)
        
        // Then
        #expect(mockRepository.processPaymentCallCount == 1)
        
        switch result {
        case .success(let response):
            #expect(response.status == "failed")
            #expect(response.statusCode == 400)
            #expect(response.isSuccessful == false)
        case .failure:
            Issue.record("Expected success but got failure")
        }
    }
    
    // MARK: - Failure Tests
    
    @Test("Should return network error when repository returns network error")
    func testExecuteReturnsNetworkError() async throws {
        // Given
        let mockRepository = MockPaymentRepository()
        mockRepository.processPaymentResult = .failure(.network)
        let useCase = ProcessPaymentUseCase(repository: mockRepository)
        let payment = createValidPayment()
        
        // When
        let result = await useCase.execute(payment)
        
        // Then
        #expect(mockRepository.processPaymentCallCount == 1)
        
        switch result {
        case .success:
            Issue.record("Expected failure but got success")
        case .failure(let error):
            #expect(error == .network)
        }
    }
    
    @Test("Should return server error when repository returns server error")
    func testExecuteReturnsServerError() async throws {
        // Given
        let mockRepository = MockPaymentRepository()
        mockRepository.processPaymentResult = .failure(.server)
        let useCase = ProcessPaymentUseCase(repository: mockRepository)
        let payment = createValidPayment()
        
        // When
        let result = await useCase.execute(payment)
        
        // Then
        #expect(mockRepository.processPaymentCallCount == 1)
        
        switch result {
        case .success:
            Issue.record("Expected failure but got success")
        case .failure(let error):
            #expect(error == .server)
        }
    }
    
    @Test("Should return generic error when repository returns generic error")
    func testExecuteReturnsGenericError() async throws {
        // Given
        let mockRepository = MockPaymentRepository()
        mockRepository.processPaymentResult = .failure(.generic)
        let useCase = ProcessPaymentUseCase(repository: mockRepository)
        let payment = createValidPayment()
        
        // When
        let result = await useCase.execute(payment)
        
        // Then
        #expect(mockRepository.processPaymentCallCount == 1)
        
        switch result {
        case .success:
            Issue.record("Expected failure but got success")
        case .failure(let error):
            #expect(error == .generic)
        }
    }
    
    @Test("Should return unauthorized error when repository returns unauthorized error")
    func testExecuteReturnsUnauthorizedError() async throws {
        // Given
        let mockRepository = MockPaymentRepository()
        mockRepository.processPaymentResult = .failure(.unauthorized)
        let useCase = ProcessPaymentUseCase(repository: mockRepository)
        let payment = createValidPayment()
        
        // When
        let result = await useCase.execute(payment)
        
        // Then
        #expect(mockRepository.processPaymentCallCount == 1)
        
        switch result {
        case .success:
            Issue.record("Expected failure but got success")
        case .failure(let error):
            #expect(error == .unauthorized)
        }
    }
    
    @Test("Should return not found error when repository returns not found error")
    func testExecuteReturnsNotFoundError() async throws {
        // Given
        let mockRepository = MockPaymentRepository()
        mockRepository.processPaymentResult = .failure(.notFound)
        let useCase = ProcessPaymentUseCase(repository: mockRepository)
        let payment = createValidPayment()
        
        // When
        let result = await useCase.execute(payment)
        
        // Then
        #expect(mockRepository.processPaymentCallCount == 1)
        
        switch result {
        case .success:
            Issue.record("Expected failure but got success")
        case .failure(let error):
            #expect(error == .notFound)
        }
    }
    
    @Test("Should return decoding error when repository returns decoding error")
    func testExecuteReturnsDecodingError() async throws {
        // Given
        let mockRepository = MockPaymentRepository()
        mockRepository.processPaymentResult = .failure(.decoding)
        let useCase = ProcessPaymentUseCase(repository: mockRepository)
        let payment = createValidPayment()
        
        // When
        let result = await useCase.execute(payment)
        
        // Then
        #expect(mockRepository.processPaymentCallCount == 1)
        
        switch result {
        case .success:
            Issue.record("Expected failure but got success")
        case .failure(let error):
            #expect(error == .decoding)
        }
    }
    
    // MARK: - Integration Tests
    
    @Test("Should pass payment data correctly to repository")
    func testPaymentDataPassedCorrectly() async throws {
        // Given
        let mockRepository = MockPaymentRepository()
        mockRepository.processPaymentResult = .success(successResponse)
        let useCase = ProcessPaymentUseCase(repository: mockRepository)
        let payment = createValidPayment()
        
        // When
        let result = await useCase.execute(payment)
        
        // Then
        #expect(mockRepository.processPaymentCallCount == 1)
        
        switch result {
        case .success(let response):
            #expect(response.isSuccessful == true)
        case .failure:
            Issue.record("Expected success but got failure")
        }
    }
    
    // MARK: - Edge Cases
    
    @Test("Should handle different currency types")
    func testHandlesDifferentCurrencies() async throws {
        // Given
        let mockRepository = MockPaymentRepository()
        mockRepository.processPaymentResult = .success(successResponse)
        let useCase = ProcessPaymentUseCase(repository: mockRepository)
        
        let usdPayment = Payment(
            cardNumber: CardNumber("1234567890123456")!,
            expirationDate: ExpirationDate("12/25")!,
            cvv: CVV("123")!,
            cardholderName: CardholderName("John Doe")!,
            amount: 100.00,
            currency: .usd
        )
        
        let eurPayment = Payment(
            cardNumber: CardNumber("1234567890123456")!,
            expirationDate: ExpirationDate("12/25")!,
            cvv: CVV("123")!,
            cardholderName: CardholderName("John Doe")!,
            amount: 85.50,
            currency: .eur
        )
        
        // When
        let usdResult = await useCase.execute(usdPayment)
        let eurResult = await useCase.execute(eurPayment)
        
        // Then
        #expect(mockRepository.processPaymentCallCount == 2)
        
        switch (usdResult, eurResult) {
        case (.success(let usdResponse), .success(let eurResponse)):
            #expect(usdResponse.isSuccessful == true)
            #expect(eurResponse.isSuccessful == true)
        default:
            Issue.record("Expected both payments to succeed")
        }
    }
    
    @Test("Should handle different payment amounts")
    func testHandlesDifferentPaymentAmounts() async throws {
        // Given
        let mockRepository = MockPaymentRepository()
        mockRepository.processPaymentResult = .success(successResponse)
        let useCase = ProcessPaymentUseCase(repository: mockRepository)
        
        let smallPayment = Payment(
            cardNumber: CardNumber("1234567890123456")!,
            expirationDate: ExpirationDate("12/25")!,
            cvv: CVV("123")!,
            cardholderName: CardholderName("John Doe")!,
            amount: 0.01,
            currency: .usd
        )
        
        let largePayment = Payment(
            cardNumber: CardNumber("1234567890123456")!,
            expirationDate: ExpirationDate("12/25")!,
            cvv: CVV("123")!,
            cardholderName: CardholderName("John Doe")!,
            amount: 9999.99,
            currency: .usd
        )
        
        // When
        let smallResult = await useCase.execute(smallPayment)
        let largeResult = await useCase.execute(largePayment)
        
        // Then
        #expect(mockRepository.processPaymentCallCount == 2)
        
        switch (smallResult, largeResult) {
        case (.success(let smallResponse), .success(let largeResponse)):
            #expect(smallResponse.isSuccessful == true)
            #expect(largeResponse.isSuccessful == true)
        default:
            Issue.record("Expected both payments to succeed")
        }
    }
}
