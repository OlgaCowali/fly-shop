//
//  CardPaymentViewModel.swift
//  fly-shop
//
//  Created by Olga Covaliova on 20.10.2025.
//

import Foundation
import SwiftUI

@MainActor
final class CardPaymentViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var cardNumber: String = ""
    @Published var expirationDate: String = ""
    @Published var cvv: String = ""
    @Published var cardholderName: String = ""
    @Published var isProcessing: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - Private Properties
    
    private let paymentService: CardPaymentService
    private let totalAmount: Decimal
    let currency: Currency
    
    // MARK: - Initialization
    
    init(
        paymentService: CardPaymentService,
        totalAmount: Decimal,
        currency: Currency
    ) {
        self.paymentService = paymentService
        self.totalAmount = totalAmount
        self.currency = currency
    }
    
    // MARK: - Computed Properties
    
    var isFormValid: Bool {
        return !cardNumber.isEmpty &&
               !expirationDate.isEmpty &&
               !cvv.isEmpty &&
               !cardholderName.isEmpty &&
               cardNumber.count >= 16 &&
               expirationDate.count == 5 &&
               cvv.count >= 3 &&
               isCardholderNameValid
    }
    
    var formattedTotal: String {
        PriceFormatter.formatPrice(price: totalAmount, currency: currency) ?? "0.00"
    }
    
    var isCardholderNameValid: Bool {
        return !cardholderName.isEmpty && cardholderName.allSatisfy { $0.isLetter || $0.isWhitespace }
    }
    
    // MARK: - Public Methods
    
    func validateCardNumber(_ number: String) {
        cardNumber = CardFormatter.formatCardNumber(number)
        clearError()
    }
    
    func validateExpirationDate(_ date: String) {
        expirationDate = CardFormatter.formatExpirationDate(date)
        clearError()
    }
    
    func validateCVV(_ cvvValue: String) {
        cvv = CardFormatter.formatCVV(cvvValue)
        clearError()
    }
    
    func validateCardholderName(_ name: String) {
        cardholderName = CardFormatter.formatCardholderName(name)
        clearError()
    }
    
    func processPayment() async -> PaymentResult {
        guard isFormValid else {
            return PaymentResult.failure(
                error: DomainError.generic,
                message: CartConstants.invalidFormMessage
            )
        }
        
        isProcessing = true
        clearError()
        
        do {
            let result = try await paymentService.processCardPayment(
                cardNumber: cardNumber,
                expirationDate: expirationDate,
                cvv: cvv,
                cardholderName: cardholderName,
                totalAmount: totalAmount,
                currency: currency
            )
            
            isProcessing = false
            
            if !result.isSuccess {
                errorMessage = result.message ?? CartConstants.paymentFailedMessage
            }
            
            return result
            
        } catch {
            isProcessing = false
            errorMessage = "\(CartConstants.paymentProcessingFailedMessage) \(error.localizedDescription)"
            return PaymentResult.failure(error: error, message: errorMessage)
        }
    }
    
    func clearError() {
        errorMessage = nil
    }
    
}
