//
//  CartHeaderView.swift
//  fly-shop
//
//  Created by Olga Covaliova on 20.10.2025.
//

import SwiftUI

// Header view for the cart screen displaying title, subtitle, and close button
struct CartHeaderView: View {
    let onDismiss: () -> Void
    
    var body: some View {
        HStack {
            // Left side: Title and subtitle section
            VStack(alignment: .leading, spacing: CartConstants.headerVerticalSpacing) {
                // Main receipt title
                Text(CartConstants.receiptTitle)
                    .font(CartConstants.receiptTitleFont)
                    .fontWeight(CartConstants.receiptTitleFontWeight)
                    .foregroundColor(.primary)
                
                // Subtitle showing selected products count
                Text(CartConstants.selectedProductsSubtitle)
                    .font(CartConstants.subtitleFont)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Right side: Close button
            Button(action: onDismiss) {
                Image(systemName: CartConstants.closeButton)
                    .font(CartConstants.closeButtonFont)
                    .foregroundColor(.primary)
                    .frame(width: CartConstants.closeButtonFrame, height: CartConstants.closeButtonFrame)
                    .background(CartConstants.closeButtonBackgroundColor)
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, CartConstants.horizontalPadding)
        .padding(.top, CartConstants.topPadding)
        .padding(.bottom, CartConstants.bottomPadding)
    }
}

#Preview {
    CartHeaderView(onDismiss: {})
}
