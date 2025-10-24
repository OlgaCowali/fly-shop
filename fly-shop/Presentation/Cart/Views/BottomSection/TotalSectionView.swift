//
//  TotalSectionView.swift
//  fly-shop
//
//  Created by Olga Covaliova on 20.10.2025.
//

import SwiftUI

// View displaying the total amount with right-aligned layout
struct TotalSectionView: View {
    let totalAmount: String
    
    var body: some View {
        VStack(alignment: .trailing, spacing: CartConstants.totalSectionSpacing) {
            Text(CartConstants.totalLabel)
                .font(CartConstants.labelFont)
                .fontWeight(CartConstants.labelFontWeight)
                .foregroundColor(.secondary)
            
            Text(totalAmount)
                .font(CartConstants.totalAmountFont)
                .fontWeight(CartConstants.totalAmountFontWeight)
                .foregroundColor(.primary)
        }
    }
}
