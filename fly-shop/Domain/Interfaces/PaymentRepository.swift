//
//  PaymentRepository.swift
//  fly-shop
//
//  Created by Olga Covaliova on 24.10.2025.
//

import Foundation

protocol PaymentRepository {
    func processPayment(_ payment: Payment) async -> Result<PaymentResponseDTO, DomainError>
}

