//
//  PaymentResult.swift
//  fly-shop
//
//  Created by Olga Covaliova on 24.10.2025.
//
import Foundation

struct PaymentResult {
    let isSuccess: Bool
    let changeAmount: Decimal
    let message: String?
    let error: Error?
    
    static func success(changeAmount: Decimal, message: String? = nil) -> PaymentResult {
        PaymentResult(isSuccess: true, changeAmount: changeAmount, message: message, error: nil)
    }
    
    static func failure(error: Error, message: String? = nil) -> PaymentResult {
        PaymentResult(isSuccess: false, changeAmount: 0, message: message, error: error)
    }
}
