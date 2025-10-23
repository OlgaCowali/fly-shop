//
//  PaymentButtonSection.swift
//  fly-shop
//
//  Created by Olga Covaliova on 20.10.2025.
//

import SwiftUI

struct PaymentButtonSection: View {
    let totalAmount: Decimal
    let selectedCurrency: Currency
    let selectedCustomerType: CustomerType
    let onPayButtonTapped: () -> Void
    let onCustomerTypeButtonTapped: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                PaymentButtonBackground(geometry: geometry)
                PaymentButtonOverlays(
                    geometry: geometry,
                    totalAmount: totalAmount,
                    selectedCurrency: selectedCurrency,
                    selectedCustomerType: selectedCustomerType,
                    onPayButtonTapped: onPayButtonTapped,
                    onCustomerTypeButtonTapped: onCustomerTypeButtonTapped
                )
            }
        }
        .frame(height: ProductListConstants.paymentButtonHeight)
    }
}

// MARK: - Background Component

private struct PaymentButtonBackground: View {
    let geometry: GeometryProxy
    
    var body: some View {
        RoundedRectangle(cornerRadius: ProductListConstants.paymentCornerRadius)
            .fill(Color.clear)
            .overlay(backgroundGradient)
    }
    
    private var backgroundGradient: some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(ProductListConstants.paymentPayButtonBackground)
                .frame(width: geometry.size.width * ProductListConstants.paymentPayButtonWidthRatio)
            
            Rectangle()
                .fill(ProductListConstants.paymentCustomerTypeButtonBackground)
                .frame(width: geometry.size.width * ProductListConstants.paymentCustomerTypeButtonWidthRatio)
        }
        .clipShape(RoundedRectangle(cornerRadius: ProductListConstants.paymentCornerRadius))
    }
}

// MARK: - Button Overlays Component

// Arranges the interactive button overlays in a horizontal stack
private struct PaymentButtonOverlays: View {
    let geometry: GeometryProxy
    let totalAmount: Decimal
    let selectedCurrency: Currency
    let selectedCustomerType: CustomerType
    let onPayButtonTapped: () -> Void
    let onCustomerTypeButtonTapped: () -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            // Pay button with formatted amount and currency
            PayButton(
                geometry: geometry,
                totalAmount: totalAmount,
                selectedCurrency: selectedCurrency,
                onPayButtonTapped: onPayButtonTapped
            )
            
            // Customer type selector button
            CustomerTypeButton(
                geometry: geometry,
                selectedCustomerType: selectedCustomerType,
                onCustomerTypeButtonTapped: onCustomerTypeButtonTapped
            )
        }
    }
}

// MARK: - Pay Button Component

private struct PayButton: View {
    let geometry: GeometryProxy
    let totalAmount: Decimal
    let selectedCurrency: Currency
    let onPayButtonTapped: () -> Void
    
    // Formats the payment amount and currency for display in the button
    private var formattedPaymentText: (amount: String, currency: String) {
        PriceFormatter.formatPaymentComponents(price: totalAmount, currency: selectedCurrency)
    }
    
    var body: some View {
        Button(action: onPayButtonTapped) {
            let formatted = formattedPaymentText
            
            // Combine text elements with different font weights for visual hierarchy
            (Text(ProductListConstants.payButtonTitle)
                .font(.headline)
                .fontWeight(.semibold) +
             Text(" \(formatted.amount)")
                .font(.headline)
                .fontWeight(.heavy) +
             Text(" \(formatted.currency)")
                .font(.headline)
                .fontWeight(.semibold))
                .foregroundColor(ProductListConstants.paymentTextColor)
                .frame(
                    width: geometry.size.width * ProductListConstants.paymentPayButtonWidthRatio,
                    height: ProductListConstants.paymentButtonHeight
                )
                .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .background(Color.clear)
    }
}

// MARK: - Customer Type Button Component

// Customer type selector button that displays the currently selected customer type
private struct CustomerTypeButton: View {
    let geometry: GeometryProxy
    let selectedCustomerType: CustomerType
    let onCustomerTypeButtonTapped: () -> Void
    
    var body: some View {
        Button(action: onCustomerTypeButtonTapped) {
            Text(selectedCustomerType.name)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(ProductListConstants.paymentTextColor)
                .frame(
                    width: geometry.size.width * ProductListConstants.paymentCustomerTypeButtonWidthRatio,
                    height: ProductListConstants.paymentButtonHeight
                )
                .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .background(Color.clear)
    }
}
