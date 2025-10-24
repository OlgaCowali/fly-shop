//
//  CashPaymentViewModel.swift
//  fly-shop
//
//  Created by Olga Covaliova on 20.10.2025.
//

import Foundation
import SwiftUI

@MainActor
final class CashPaymentViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var enteredAmount: String = ""
    @Published var isValidAmount: Bool = false
    @Published var isProcessing: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - Private Properties
    
    private let paymentService: CashPaymentService
    private let totalAmount: Decimal
    let currency: Currency
    
    // MARK: - Initialization
    
    init(
        paymentService: CashPaymentService,
        totalAmount: Decimal,
        currency: Currency
    ) {
        self.paymentService = paymentService
        self.totalAmount = totalAmount
        self.currency = currency
    }
    
    // MARK: - Computed Properties
    
    var changeAmount: Decimal {
        guard let entered = Decimal(string: enteredAmount) else { return 0 }
        return paymentService.calculateChange(amountPaid: entered, totalAmount: totalAmount)
    }
    
    var formattedChange: String {
        PriceFormatter.formatPrice(price: changeAmount, currency: currency) ?? "0.00"
    }
    
    var formattedTotal: String {
        PriceFormatter.formatPrice(price: totalAmount, currency: currency) ?? "0.00"
    }
    
    var formattedAmountPaid: String {
        guard let amount = Decimal(string: enteredAmount) else { return "0.00" }
        return PriceFormatter.formatPrice(price: amount, currency: currency) ?? "0.00"
    }
    
    // MARK: - Public Methods
    
    func validateAmount(_ amount: String) {
        enteredAmount = amount
        isValidAmount = paymentService.validatePaymentAmount(amount, against: totalAmount)
        clearError()
    }
    
    func processPayment() async -> PaymentResult {
        guard isValidAmount else {
            return PaymentResult.failure(
                error: DomainError.generic,
                message: CartConstants.invalidPaymentAmountMessage
            )
        }
        
        guard let amountPaid = Decimal(string: enteredAmount) else {
            return PaymentResult.failure(
                error: DomainError.generic,
                message: CartConstants.invalidAmountFormatMessage
            )
        }
        
        isProcessing = true
        clearError()
        
        do {
            let result = try await paymentService.processCashPayment(
                amountPaid: amountPaid,
                totalAmount: totalAmount
            )
            
            isProcessing = false
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
