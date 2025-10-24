//
//  CartBottomSectionView.swift
//  fly-shop
//
//  Created by Olga Covaliova on 20.10.2025.
//

import SwiftUI

// Main bottom section view that combines seat information, total amount, and payment options
struct CartBottomSectionView: View {
    @Binding var selectedSeat: String
    let totalAmount: String
    let onCashPayment: () -> Void
    let onCardPayment: () -> Void
    
    var body: some View {
        VStack(spacing: CartConstants.bottomSectionSpacing) {
            // Seat and Total row
            HStack {
                SeatSectionView(selectedSeat: $selectedSeat)
                    .padding(.leading, CartConstants.seatSectionLeadingPadding)
                Spacer()
                
                TotalSectionView(totalAmount: totalAmount)
            }
            .padding(.horizontal, CartConstants.bottomSectionHorizontalPadding)
            // Payment buttons
            PaymentButtonsView(
                onCashPayment: onCashPayment,
                onCardPayment: onCardPayment
            )
        }
        .padding(.top, CartConstants.topPadding)
        .padding(.bottom, CartConstants.bottomSectionBottomPadding)
        .background(Color(.systemBackground))
    }
}

