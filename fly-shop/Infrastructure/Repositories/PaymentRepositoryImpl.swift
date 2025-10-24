//
//  PaymentRepositoryImpl.swift
//  fly-shop
//
//  Created by Olga Covaliova on 24.10.2025.
//

import Foundation

class PaymentRepositoryImpl: PaymentRepository {
    
    private let apiDataSource: APIPaymentDataSource
    
    init(apiDataSource: APIPaymentDataSource) {
        self.apiDataSource = apiDataSource
    }
    
    func processPayment(_ payment: Payment) async -> Result<PaymentResponseDTO, DomainError> {
        // Map domain Payment entity to PaymentRequestDTO
        let requestDTO = PaymentRequestDTO(from: payment)
        
        let result = await apiDataSource.processPayment(request: requestDTO)
        
        switch result {
        case .success(let paymentResponse):
            return .success(paymentResponse)
            
        case .failure(let httpError):
            // Map HTTP errors to domain errors
            let domainError: DomainError
            switch httpError {
            case .clientError:  domainError = .network
            case .serverError:  domainError = .server
            case .parsingError: domainError = .decoding
            case .responseError: domainError = .network
            case .generic:      domainError = .generic
            }
            return .failure(domainError)
        }
    }
}

