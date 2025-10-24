//
//  APIPaymentDataSourceImplTests.swift
//  fly-shop
//
//  Created by Olga Covaliova on 24.10.2025.
//

import Foundation
import Testing
@testable import fly_shop

struct APIPaymentDataSourceImplTests {
    
    // MARK: - Test Data
    
    private let samplePaymentRequest: PaymentRequestDTO = {
        let payment = Payment(
            cardNumber: CardNumber("1234567890123456")!,
            expirationDate: ExpirationDate("12/25")!,
            cvv: CVV("123")!,
            cardholderName: CardholderName("John Doe")!,
            amount: 100.00,
            currency: .usd
        )
        return PaymentRequestDTO(from: payment)
    }()
    
    private let samplePaymentResponse = PaymentResponseDTO(
        status: "success",
        statusCode: 200
    )
    
    // MARK: - Success Tests
    
    @Test("Should process payment successfully with valid response")
    func testProcessPaymentSuccess() async {
        // Given
        let mockHTTPClient = MockHTTPClient()
        let responseData = try! JSONEncoder().encode(samplePaymentResponse)
        mockHTTPClient.setSuccessResult(data: responseData)
        
        let dataSource = APIPaymentDataSourceImpl(httpClient: mockHTTPClient)
        
        // When
        let result = await dataSource.processPayment(request: samplePaymentRequest)
        
        // Then
        #expect(mockHTTPClient.makeRequestCallCount == 1)
        #expect(mockHTTPClient.lastEndpoint?.method == .post)
        #expect(mockHTTPClient.lastEndpoint?.path == APIConstant.paymentGatewayURL)
        
        switch result {
        case .success(let response):
            #expect(response.status == "success")
            #expect(response.statusCode == 200)
        case .failure:
            Issue.record("Expected success but got failure")
        }
    }
    
    @Test("Should process payment successfully when gateway echoes request")
    func testProcessPaymentEchoSuccess() async {
        // Given
        let mockHTTPClient = MockHTTPClient()
        let echoData = try! JSONEncoder().encode(samplePaymentRequest)
        mockHTTPClient.setSuccessResult(data: echoData)
        
        let dataSource = APIPaymentDataSourceImpl(httpClient: mockHTTPClient)
        
        // When
        let result = await dataSource.processPayment(request: samplePaymentRequest)
        
        // Then
        switch result {
        case .success(let response):
            #expect(response.status == "success")
            #expect(response.statusCode == 200)
        case .failure:
            Issue.record("Expected success but got failure")
        }
    }
    
    // MARK: - Error Tests
    
    @Test("Should return parsing error for invalid response data")
    func testProcessPaymentParsingError() async {
        // Given
        let mockHTTPClient = MockHTTPClient()
        let invalidData = "invalid json".data(using: .utf8)!
        mockHTTPClient.setSuccessResult(data: invalidData)
        
        let dataSource = APIPaymentDataSourceImpl(httpClient: mockHTTPClient)
        
        // When
        let result = await dataSource.processPayment(request: samplePaymentRequest)
        
        // Then
        switch result {
        case .success:
            Issue.record("Expected parsing error but got success")
        case .failure(let error):
            #expect(error == .parsingError)
        }
    }
    
    @Test("Should return client error when HTTP client fails")
    func testProcessPaymentClientError() async {
        // Given
        let mockHTTPClient = MockHTTPClient()
        mockHTTPClient.setFailureResult(error: .clientError)
        
        let dataSource = APIPaymentDataSourceImpl(httpClient: mockHTTPClient)
        
        // When
        let result = await dataSource.processPayment(request: samplePaymentRequest)
        
        // Then
        switch result {
        case .success:
            Issue.record("Expected client error but got success")
        case .failure(let error):
            #expect(error == .clientError)
        }
    }
    
    @Test("Should return server error when HTTP client fails")
    func testProcessPaymentServerError() async {
        // Given
        let mockHTTPClient = MockHTTPClient()
        mockHTTPClient.setFailureResult(error: .serverError)
        
        let dataSource = APIPaymentDataSourceImpl(httpClient: mockHTTPClient)
        
        // When
        let result = await dataSource.processPayment(request: samplePaymentRequest)
        
        // Then
        switch result {
        case .success:
            Issue.record("Expected server error but got success")
        case .failure(let error):
            #expect(error == .serverError)
        }
    }
    
    @Test("Should return generic error when HTTP client fails")
    func testProcessPaymentGenericError() async {
        // Given
        let mockHTTPClient = MockHTTPClient()
        mockHTTPClient.setFailureResult(error: .generic)
        
        let dataSource = APIPaymentDataSourceImpl(httpClient: mockHTTPClient)
        
        // When
        let result = await dataSource.processPayment(request: samplePaymentRequest)
        
        // Then
        switch result {
        case .success:
            Issue.record("Expected generic error but got success")
        case .failure(let error):
            #expect(error == .generic)
        }
    }
    
    // MARK: - Edge Cases
    
    @Test("Should create correct endpoint with POST method and body")
    func testEndpointCreation() async {
        // Given
        let mockHTTPClient = MockHTTPClient()
        let responseData = try! JSONEncoder().encode(samplePaymentResponse)
        mockHTTPClient.setSuccessResult(data: responseData)
        
        let dataSource = APIPaymentDataSourceImpl(httpClient: mockHTTPClient)
        
        // When
        _ = await dataSource.processPayment(request: samplePaymentRequest)
        
        // Then
        #expect(mockHTTPClient.lastEndpoint?.method == .post)
        #expect(mockHTTPClient.lastEndpoint?.path == APIConstant.paymentGatewayURL)
        #expect(mockHTTPClient.lastEndpoint?.body != nil)
        
        // Verify the request body contains the payment data
        if let body = mockHTTPClient.lastEndpoint?.body {
            let decodedRequest = try! JSONDecoder().decode(PaymentRequestDTO.self, from: body)
            #expect(decodedRequest.cardNumber == samplePaymentRequest.cardNumber)
            #expect(decodedRequest.amount == samplePaymentRequest.amount)
        }
    }
    
    @Test("Should handle empty response data")
    func testProcessPaymentEmptyResponse() async {
        // Given
        let mockHTTPClient = MockHTTPClient()
        mockHTTPClient.setSuccessResult(data: Data())
        
        let dataSource = APIPaymentDataSourceImpl(httpClient: mockHTTPClient)
        
        // When
        let result = await dataSource.processPayment(request: samplePaymentRequest)
        
        // Then
        switch result {
        case .success:
            Issue.record("Expected parsing error for empty data but got success")
        case .failure(let error):
            #expect(error == .parsingError)
        }
    }
}

