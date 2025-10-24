//
//  PaymentButtonsView.swift
//  fly-shop
//
//  Created by Olga Covaliova on 20.10.2025.
//

import SwiftUI

// View containing cash and card payment buttons with consistent styling
struct PaymentButtonsView: View {
    let onCashPayment: () -> Void
    let onCardPayment: () -> Void
    
    var body: some View {
        HStack(spacing: CartConstants.paymentButtonsSpacing) {
            // Cash payment button with icon and text
            Button(action: onCashPayment) {
                VStack(spacing: CartConstants.buttonContentSpacing) {
                    Image(systemName: CartConstants.cashButtonIcon)
                        .font(CartConstants.buttonIconFont)
                        .foregroundColor(CartConstants.buttonTextColor)
                    
                    Text(CartConstants.cashButtonText)
                        .font(CartConstants.buttonTextFont)
                        .fontWeight(CartConstants.buttonTextFontWeight)
                        .foregroundColor(CartConstants.buttonTextColor)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, CartConstants.buttonVerticalPadding)
                .background(
                    RoundedRectangle(cornerRadius: CartConstants.buttonCornerRadius)
                        .fill(CartConstants.cashButtonBackgroundColor)
                )
            }
            .buttonStyle(PlainButtonStyle())
            
            // Card payment button with icon and text
            Button(action: onCardPayment) {
                VStack(spacing: CartConstants.buttonContentSpacing) {
                    Image(systemName: CartConstants.cardButtonIcon)
                        .font(CartConstants.buttonIconFont)
                        .foregroundColor(CartConstants.buttonTextColor)
                    
                    Text(CartConstants.cardButtonText)
                        .font(CartConstants.buttonTextFont)
                        .fontWeight(CartConstants.buttonTextFontWeight)
                        .foregroundColor(CartConstants.buttonTextColor)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, CartConstants.buttonVerticalPadding)
                .background(
                    RoundedRectangle(cornerRadius: CartConstants.buttonCornerRadius)
                        .fill(CartConstants.cardButtonBackgroundColor)
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, CartConstants.bottomSectionHorizontalPadding)
    }
}

