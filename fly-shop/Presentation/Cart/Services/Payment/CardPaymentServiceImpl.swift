//
//  CardPaymentServiceImpl.swift
//  fly-shop
//
//  Created by Olga Covaliova on 20.10.2025.
//

import Foundation

final class CardPaymentServiceImpl: CardPaymentService {
    
    // MARK: - Properties
    
    private let processPaymentUseCase: ProcessPayment
    
    // MARK: - Initialization
    
    init(processPaymentUseCase: ProcessPayment) {
        self.processPaymentUseCase = processPaymentUseCase
    }
    
    // MARK: - CardPaymentService Implementation
    
    func validateCardDetails(
        cardNumber: String,
        expirationDate: String,
        cvv: String,
        cardholderName: String
    ) -> Bool {
        return validateCardNumber(cardNumber) &&
               validateExpirationDate(expirationDate) &&
               validateCVV(cvv) &&
               validateCardholderName(cardholderName)
    }
    
    func processCardPayment(
        cardNumber: String,
        expirationDate: String,
        cvv: String,
        cardholderName: String,
        totalAmount: Decimal,
        currency: Currency
    ) async throws -> PaymentResult {
        
        // Create value objects (validation happens in their initializers)
        guard let validCardNumber = CardNumber(cardNumber),
              let validExpirationDate = ExpirationDate(expirationDate),
              let validCVV = CVV(cvv),
              let validCardholderName = CardholderName(cardholderName) else {
            return PaymentResult.failure(
                error: DomainError.generic,
                message: CartConstants.invalidFormMessage
            )
        }
        
        // Create domain payment entity with validated value objects
        let payment = Payment(
            cardNumber: validCardNumber,
            expirationDate: validExpirationDate,
            cvv: validCVV,
            cardholderName: validCardholderName,
            amount: totalAmount,
            currency: currency
        )
        
        // Process payment through use case
        let result = await processPaymentUseCase.execute(payment)
        
        switch result {
        case .success(let paymentResponse):
            print(paymentResponse)
            // Check if payment was successful based on status response
            if paymentResponse.isSuccessful {
                return PaymentResult.success(
                    changeAmount: 0, // No change for card payments
                    message: CartConstants.paymentProcessedSuccessfullyMessage
                )
            } else {
                return PaymentResult.failure(
                    error: DomainError.generic,
                    message: CartConstants.paymentFailedMessage(
                        status: paymentResponse.status,
                        statusCode: paymentResponse.statusCode
                    )
                )
            }
            
        case .failure(let error):
            // Map domain errors to user-friendly messages
            let errorMessage: String
            switch error {
            case .network:
                errorMessage = CartConstants.networkErrorMessage
            case .server:
                errorMessage = CartConstants.serverUnavailableMessage
            case .decoding:
                errorMessage = CartConstants.invalidResponseMessage
            case .unauthorized:
                errorMessage = CartConstants.authorizationFailedMessage
            case .notFound:
                errorMessage = CartConstants.serviceNotFoundMessage
            case .generic:
                errorMessage = CartConstants.genericPaymentErrorMessage
            }
            
            return PaymentResult.failure(
                error: error,
                message: errorMessage
            )
        }
    }
    
    // MARK: - Validation Methods (delegate to value objects)
    
    func validateCardNumber(_ cardNumber: String) -> Bool {
        return CardNumber(cardNumber) != nil
    }
    
    func validateExpirationDate(_ expirationDate: String) -> Bool {
        return ExpirationDate(expirationDate) != nil
    }
    
    func validateCVV(_ cvv: String) -> Bool {
        return CVV(cvv) != nil
    }
    
    func validateCardholderName(_ name: String) -> Bool {
        return CardholderName(name) != nil
    }
}
