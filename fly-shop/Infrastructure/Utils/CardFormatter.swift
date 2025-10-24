//
//  CardFormatter.swift
//  fly-shop
//
//  Created by Olga Covaliova on 20.10.2025.
//

import Foundation

// Utility struct for formatting card-related input fields
struct CardFormatter {
    
    // Formats card number with spaces every 4 digits (e.g., "1234 5678 9012 3456")
    static func formatCardNumber(_ input: String) -> String {
        let cleaned = input.replacingOccurrences(of: " ", with: "")
        let limited = String(cleaned.prefix(16))
        
        var formatted = ""
        for (index, character) in limited.enumerated() {
            if index > 0 && index % 4 == 0 {
                formatted += " "
            }
            formatted += String(character)
        }
        
        return formatted
    }
    
    // Formats expiration date as MM/YY
    static func formatExpirationDate(_ input: String) -> String {
        let cleaned = input.replacingOccurrences(of: "/", with: "")
        let limited = String(cleaned.prefix(4))
        
        if limited.count >= 2 {
            let month = String(limited.prefix(2))
            let year = String(limited.dropFirst(2))
            return "\(month)/\(year)"
        }
        
        return limited
    }
    
    // Validates and formats CVV (3-4 digits)
    static func formatCVV(_ input: String) -> String {
        let cleaned = input.filter { $0.isNumber }
        return String(cleaned.prefix(4))
    }
    
    // Validates and formats cardholder name (letters and spaces only)
    static func formatCardholderName(_ input: String) -> String {
        return input.filter { $0.isLetter || $0.isWhitespace }
    }
}
