//
//  PaymentResponseDTO.swift
//  fly-shop
//
//  Created by Olga Covaliova on 24.10.2025.
//

import Foundation

// DTO representing the payment gateway response
struct PaymentResponseDTO: Codable {
    let status: String
    let statusCode: Int
    
    enum CodingKeys: String, CodingKey {
        case status
        case statusCode = "status_code"
    }
    
    // Helper to check if payment was successful
    var isSuccessful: Bool {
        return status.lowercased() == "success" && statusCode == 200
    }
}

