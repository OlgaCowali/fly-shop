//
//  CurrencyConversionSection.swift
//  fly-shop
//
//  Created by Olga Covaliova on 20.10.2025.
//

import SwiftUI

// A view that displays alternative currency options for the current total
struct CurrencyConversionSection: View {
    let selectedCurrency: Currency
    let totalsByCurrency: [Currency: Decimal]
    let onCurrencyChange: (Currency) -> Void
    
    // Returns all available currencies except the currently selected one
    private var otherCurrencies: [Currency] {
        Currency.all.filter { $0 != selectedCurrency }
    }
    
    var body: some View {
        HStack {
            // Display each alternative currency as a tappable button
            ForEach(Array(otherCurrencies.enumerated()), id: \.element) { index, currency in
                if let total = totalsByCurrency[currency],
                   let formatted = PriceFormatter.formatPrice(price: total, currency: currency) {
                    
                    CurrencyButton(
                        formattedPrice: formatted,
                        currency: currency,
                        onCurrencyChange: onCurrencyChange
                    )
                    
                    // Add divider between currency buttons (except after the last one)
                    if index < otherCurrencies.count - 1 {
                        Text(ProductListConstants.currencyDivider)
                            .font(.subheadline)
                    }
                }
            }
        }
    }
}

// A tappable button that displays a formatted price in a specific currency
private struct CurrencyButton: View {
    let formattedPrice: String
    let currency: Currency
    let onCurrencyChange: (Currency) -> Void
    
    var body: some View {
        Button(action: { onCurrencyChange(currency) }) {
            Text(formattedPrice)
                .font(.subheadline)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
