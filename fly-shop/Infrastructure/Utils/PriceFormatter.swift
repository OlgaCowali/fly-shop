//
//  PriceFormatter.swift
//  fly-shop
//
//  Created by Olga Covaliova on 20.10.2025.
//

import Foundation

// Utility struct for formatting currency values with proper locale support
struct PriceFormatter {
    
    // Formats a decimal price value into a localized currency string (e.g., "$1,234.56")
    static func formatPrice(price: Decimal, currency: Currency = .usd, locale: Locale? = nil) -> String? {
        // Create a number formatter configured for currency display
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency.rawValue
        formatter.currencySymbol = currency.symbol
        formatter.locale = locale ?? Locale.current // Use provided locale or current locale
        formatter.minimumFractionDigits = ProductListConstants.priceMinimumFractionDigits
        formatter.maximumFractionDigits = ProductListConstants.priceMaximumFractionDigits
        
        // Convert decimal to NSDecimalNumber and format
        return formatter.string(from: NSDecimalNumber(decimal: price))
    }
    
    // Formats payment components separately for better control and reliability
    // Returns a tuple with formatted amount and currency code
    static func formatPaymentComponents(price: Decimal, currency: Currency, locale: Locale? = nil) -> (amount: String, currency: String) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = ProductListConstants.priceMinimumFractionDigits
        formatter.maximumFractionDigits = ProductListConstants.priceMaximumFractionDigits
        formatter.locale = locale ?? Locale.current // Use provided locale or current locale
        
        let amount = formatter.string(from: NSDecimalNumber(decimal: price)) ?? "\(price)"
        return (amount: amount, currency: currency.rawValue)
    }
}
