//
//  PriceBadge.swift
//  fly-shop
//
//  Created by Olga Covaliova on 20.10.2025.
//

import SwiftUI

struct PriceBadge: View {
    let product: Product
    let selectedCurrency: Currency
    
    var body: some View {
        Group {
            if let price = product.prices[selectedCurrency], let formattedPrice = PriceFormatter.formatPrice(price: price, currency: selectedCurrency) {
                Text(formattedPrice)
                    .font(ProductListConstants.priceFont)
                    .fontWeight(ProductListConstants.priceFontWeight)
                    .foregroundColor(ProductListConstants.priceTextColor)
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: false)
                    .padding(.horizontal, ProductListConstants.priceBadgeHorizontalPadding)
                    .padding(.vertical, ProductListConstants.priceBadgeVerticalPadding)
                    .background(ProductListConstants.priceBadgeBackground)
                    .cornerRadius(ProductListConstants.priceBadgeCornerRadius)
            }
        }
    }
}
