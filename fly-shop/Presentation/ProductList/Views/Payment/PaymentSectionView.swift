//
//  PaymentSectionView.swift
//  fly-shop
//
//  Created by Olga Covaliova on 20.10.2025.
//

import SwiftUI

struct PaymentSectionView: View {
    let totalAmount: Decimal
    let selectedCurrency: Currency
    let totalsByCurrency: [Currency: Decimal] // Pre-calculated totals for each currency
    let selectedCustomerType: CustomerType
    let customerTypes: [CustomerType]
    let onCustomerTypeChange: (CustomerType) -> Void
    let onPayButtonTapped: () -> Void
    let onCurrencyChange: (Currency) -> Void
    
    @State private var isShowingCustomerTypeActionSheet = false
    
    var body: some View {
        VStack(spacing: ProductListConstants.paymentVerticalSpacing) {
            // Main payment button with customer type selection
            PaymentButtonSection(
                totalAmount: totalAmount,
                selectedCurrency: selectedCurrency,
                selectedCustomerType: selectedCustomerType,
                onPayButtonTapped: onPayButtonTapped,
                onCustomerTypeButtonTapped: { isShowingCustomerTypeActionSheet = true }
            )
            
            // Currency conversion section showing totals in different currencies
            CurrencyConversionSection(
                selectedCurrency: selectedCurrency,
                totalsByCurrency: totalsByCurrency,
                onCurrencyChange: onCurrencyChange
            )
        }
        .padding(.horizontal, ProductListConstants.paymentHorizontalPadding)
        .padding(.top, ProductListConstants.paymentTopPadding)
        .padding(.bottom, ProductListConstants.paymentBottomPadding)
        // Action sheet for customer type selection
        .actionSheet(isPresented: $isShowingCustomerTypeActionSheet) {
            CustomerTypeActionSheet(
                customerTypes: customerTypes,
                onCustomerTypeChange: onCustomerTypeChange
            ).actionSheet
        }
    }
}


