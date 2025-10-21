//
//  PriceFormatter.swift
//  fly-shop
//
//  Created by Olga Covaliova on 20.10.2025.
//

import Foundation

// Utility struct for formatting currency values with proper locale support
struct PriceFormatter {
    
    // Formats a decimal price value into a localized currency string
    static func format(price: Decimal, currency: Currency = .usd) -> String? {
        // Create a number formatter configured for currency display
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency.rawValue
        formatter.currencySymbol = currency.symbol
        formatter.locale = Locale.current // Use current locale for proper formatting
        formatter.minimumFractionDigits = ProductListConstants.priceMinimumFractionDigits
        formatter.maximumFractionDigits = ProductListConstants.priceMaximumFractionDigits
        
        // Convert decimal to NSDecimalNumber and format
        return formatter.string(from: NSDecimalNumber(decimal: price))
    }
}
