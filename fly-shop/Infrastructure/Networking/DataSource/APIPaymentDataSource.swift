//
//  APIPaymentDataSource.swift
//  fly-shop
//
//  Created by Olga Covaliova on 24.10.2025.
//

import Foundation

protocol APIPaymentDataSource {
    func processPayment(request: PaymentRequestDTO) async -> Result<PaymentResponseDTO, HTTPClientError>
}

