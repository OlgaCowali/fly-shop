//
//  QuantityBar.swift
//  fly-shop
//
//  Created by Olga Covaliova on 20.10.2025.
//

import SwiftUI

struct QuantityBar: View {
    let quantity: Int
    let onQuantityChange: (Int) -> Void
    
    var body: some View {
        // Increment/decrement controls. "-" is hidden when quantity is 0
        HStack(spacing: ProductListConstants.quantityBarSpacing) {
            if quantity > 0 {
                
                // Only show minus button when quantity is greater than 0
            QuantityButton(
                icon: ProductListConstants.minusButtonName,
                action: { onQuantityChange(quantity - 1) },
                backgroundColor: ProductListConstants.quantityMinusButtonBackground
            )
            }
            
            QuantityButton(
                icon: ProductListConstants.plusButtonName,
                action: { onQuantityChange(quantity + 1) },
                backgroundColor: ProductListConstants.quantityPlusButtonBackground
            )
        }
        .frame(width: ProductListConstants.quantityBarFrameWidth, alignment: .leading)
    }
    
    // MARK: - Private Subviews
    
    // A reusable circular button component for quantity controls (increment/decrement)
    private struct QuantityButton: View {
        let icon: String
        let action: () -> Void
        let backgroundColor: Color
        
        var body: some View {
            Button(action: action) {
                Image(systemName: icon)
                    .font(.system(size: ProductListConstants.quantityButtonIconFontSize, weight: ProductListConstants.quantityButtonIconFontWeight))
                    .foregroundColor(ProductListConstants.buttonsForegroundColor)
                    .frame(width: ProductListConstants.quantityButtonSize, height: ProductListConstants.quantityButtonSize)
                    .background(backgroundColor)
                    .clipShape(Circle())
            }
        }
    }
}
