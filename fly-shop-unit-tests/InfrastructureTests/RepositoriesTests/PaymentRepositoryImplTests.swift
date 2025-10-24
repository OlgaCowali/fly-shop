//
//  PaymentRepositoryImplTests.swift
//  fly-shop
//
//  Created by Olga Covaliova on 24.10.2025.
//

import Testing
import Foundation
@testable import fly_shop

struct PaymentRepositoryImplTests {
    
    // MARK: - Test Data
    
    private let samplePayment = Payment(
        cardNumber: CardNumber("1234567890123456")!,
        expirationDate: ExpirationDate("12/25")!,
        cvv: CVV("123")!,
        cardholderName: CardholderName("John Doe")!,
        amount: 99.99,
        currency: .usd
    )
    
    private let samplePaymentResponse = PaymentResponseDTO(
        status: "success",
        statusCode: 200
    )
    
    // MARK: - Success Tests
    
    @Test("Should return success when data source returns success")
    func testProcessPaymentReturnsSuccessOnDataSourceSuccess() async throws {
        // Given
        let mockDataSource = MockAPIPaymentDataSource()
        mockDataSource.processPaymentResult = .success(samplePaymentResponse)
        let repository = PaymentRepositoryImpl(apiDataSource: mockDataSource)
        
        // When
        let result = await repository.processPayment(samplePayment)
        
        // Then
        #expect(mockDataSource.processPaymentCallCount == 1)
        
        switch result {
        case .success(let response):
            #expect(response.status == "success")
            #expect(response.statusCode == 200)
            #expect(response.isSuccessful == true)
        case .failure:
            Issue.record("Expected success but got failure")
        }
    }
    
    @Test("Should pass correct PaymentRequestDTO to data source")
    func testPassesCorrectPaymentRequestDTOToDataSource() async throws {
        // Given
        let mockDataSource = MockAPIPaymentDataSource()
        mockDataSource.processPaymentResult = .success(samplePaymentResponse)
        let repository = PaymentRepositoryImpl(apiDataSource: mockDataSource)
        
        // When
        _ = await repository.processPayment(samplePayment)
        
        // Then
        #expect(mockDataSource.processPaymentCallCount == 1)
    }
    
    // MARK: - Error Mapping Tests
    
    @Test("Should map clientError to network error")
    func testMapsClientErrorToNetworkError() async throws {
        // Given
        let mockDataSource = MockAPIPaymentDataSource()
        mockDataSource.processPaymentResult = .failure(.clientError)
        let repository = PaymentRepositoryImpl(apiDataSource: mockDataSource)
        
        // When
        let result = await repository.processPayment(samplePayment)
        
        // Then
        #expect(mockDataSource.processPaymentCallCount == 1)
        
        switch result {
        case .success:
            Issue.record("Expected failure but got success")
        case .failure(let error):
            #expect(error == .network)
        }
    }
    
    @Test("Should map serverError to server error")
    func testMapsServerErrorToServerError() async throws {
        // Given
        let mockDataSource = MockAPIPaymentDataSource()
        mockDataSource.processPaymentResult = .failure(.serverError)
        let repository = PaymentRepositoryImpl(apiDataSource: mockDataSource)
        
        // When
        let result = await repository.processPayment(samplePayment)
        
        // Then
        #expect(mockDataSource.processPaymentCallCount == 1)
        
        switch result {
        case .success:
            Issue.record("Expected failure but got success")
        case .failure(let error):
            #expect(error == .server)
        }
    }
    
    @Test("Should map parsingError to decoding error")
    func testMapsParsingErrorToDecodingError() async throws {
        // Given
        let mockDataSource = MockAPIPaymentDataSource()
        mockDataSource.processPaymentResult = .failure(.parsingError)
        let repository = PaymentRepositoryImpl(apiDataSource: mockDataSource)
        
        // When
        let result = await repository.processPayment(samplePayment)
        
        // Then
        #expect(mockDataSource.processPaymentCallCount == 1)
        
        switch result {
        case .success:
            Issue.record("Expected failure but got success")
        case .failure(let error):
            #expect(error == .decoding)
        }
    }
    
    @Test("Should map responseError to network error")
    func testMapsResponseErrorToNetworkError() async throws {
        // Given
        let mockDataSource = MockAPIPaymentDataSource()
        mockDataSource.processPaymentResult = .failure(.responseError)
        let repository = PaymentRepositoryImpl(apiDataSource: mockDataSource)
        
        // When
        let result = await repository.processPayment(samplePayment)
        
        // Then
        #expect(mockDataSource.processPaymentCallCount == 1)
        
        switch result {
        case .success:
            Issue.record("Expected failure but got success")
        case .failure(let error):
            #expect(error == .network)
        }
    }
    
    @Test("Should map generic error to generic error")
    func testMapsGenericErrorToGenericError() async throws {
        // Given
        let mockDataSource = MockAPIPaymentDataSource()
        mockDataSource.processPaymentResult = .failure(.generic)
        let repository = PaymentRepositoryImpl(apiDataSource: mockDataSource)
        
        // When
        let result = await repository.processPayment(samplePayment)
        
        // Then
        #expect(mockDataSource.processPaymentCallCount == 1)
        
        switch result {
        case .success:
            Issue.record("Expected failure but got success")
        case .failure(let error):
            #expect(error == .generic)
        }
    }
    
    // MARK: - Edge Cases
    
    @Test("Should handle failed payment response")
    func testHandlesFailedPaymentResponse() async throws {
        // Given
        let failedResponse = PaymentResponseDTO(status: "failed", statusCode: 400)
        let mockDataSource = MockAPIPaymentDataSource()
        mockDataSource.processPaymentResult = .success(failedResponse)
        let repository = PaymentRepositoryImpl(apiDataSource: mockDataSource)
        
        // When
        let result = await repository.processPayment(samplePayment)
        
        // Then
        #expect(mockDataSource.processPaymentCallCount == 1)
        
        switch result {
        case .success(let response):
            #expect(response.status == "failed")
            #expect(response.statusCode == 400)
            #expect(response.isSuccessful == false)
        case .failure:
            Issue.record("Expected success but got failure")
        }
    }
    
    @Test("Should handle different payment amounts")
    func testHandlesDifferentPaymentAmounts() async throws {
        // Given
        let highAmountPayment = Payment(
            cardNumber: CardNumber("1234567890123456")!,
            expirationDate: ExpirationDate("12/25")!,
            cvv: CVV("123")!,
            cardholderName: CardholderName("John Doe")!,
            amount: 9999.99,
            currency: .usd
        )
        let mockDataSource = MockAPIPaymentDataSource()
        mockDataSource.processPaymentResult = .success(samplePaymentResponse)
        let repository = PaymentRepositoryImpl(apiDataSource: mockDataSource)
        
        // When
        let result = await repository.processPayment(highAmountPayment)
        
        // Then
        #expect(mockDataSource.processPaymentCallCount == 1)
        
        switch result {
        case .success(let response):
            #expect(response.isSuccessful == true)
        case .failure:
            Issue.record("Expected success but got failure")
        }
    }
    
    @Test("Should handle different currencies")
    func testHandlesDifferentCurrencies() async throws {
        // Given
        let eurPayment = Payment(
            cardNumber: CardNumber("1234567890123456")!,
            expirationDate: ExpirationDate("12/25")!,
            cvv: CVV("123")!,
            cardholderName: CardholderName("John Doe")!,
            amount: 50.00,
            currency: .eur
        )
        let mockDataSource = MockAPIPaymentDataSource()
        mockDataSource.processPaymentResult = .success(samplePaymentResponse)
        let repository = PaymentRepositoryImpl(apiDataSource: mockDataSource)
        
        // When
        let result = await repository.processPayment(eurPayment)
        
        // Then
        #expect(mockDataSource.processPaymentCallCount == 1)
        
        switch result {
        case .success(let response):
            #expect(response.isSuccessful == true)
        case .failure:
            Issue.record("Expected success but got failure")
        }
    }
}
