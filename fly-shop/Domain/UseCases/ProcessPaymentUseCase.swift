//
//  ProcessPaymentUseCase.swift
//  fly-shop
//
//  Created by Olga Covaliova on 24.10.2025.
//

import Foundation

// Protocol defining the contract for processing a payment
protocol ProcessPayment {
    func execute(_ payment: Payment) async -> Result<PaymentResponseDTO, DomainError>
}

// Use case responsible for processing payment transactions
final class ProcessPaymentUseCase: ProcessPayment {
    
    private let repository: PaymentRepository
    
    init(repository: PaymentRepository) {
        self.repository = repository
    }
    
    func execute(_ payment: Payment) async -> Result<PaymentResponseDTO, DomainError> {
        // Delegate payment processing to the repository
        return await repository.processPayment(payment)
    }
}

