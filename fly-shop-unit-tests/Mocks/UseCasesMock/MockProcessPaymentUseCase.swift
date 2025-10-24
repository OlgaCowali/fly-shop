//
//  MockProcessPaymentUseCase.swift
//  fly-shop
//
//  Created by Olga Covaliova on 24.10.2025.
//
import Testing
import Foundation
@testable import fly_shop

final class MockProcessPaymentUseCase: ProcessPayment {
    
    var executeResult: Result<PaymentResponseDTO, DomainError> = .success(
        PaymentResponseDTO(status: "success", statusCode: 200)
    )
    var executeCallCount = 0
    var executeCalledWithPayment: Payment?
    
    func execute(_ payment: Payment) async -> Result<PaymentResponseDTO, DomainError> {
        executeCallCount += 1
        executeCalledWithPayment = payment
        return executeResult
    }
}
