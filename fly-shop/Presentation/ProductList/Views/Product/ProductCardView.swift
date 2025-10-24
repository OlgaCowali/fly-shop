//
//  ProductCardView.swift
//  fly-shop
//
//  Created by Olga Covaliova on 17.10.2025.
//

import SwiftUI
import Foundation

struct ProductCardView: View {
    let product: Product
    let selectedCurrency: Currency
    let onQuantityChange: (UUID, Int) -> Void // Callback to update quantity
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                BackgroundImage(product: product, size: geometry.size)
                gradientOverlay // Dark gradient overlay for better text readability
                contentOverlay // Product info and controls
            }
        }
        .aspectRatio(ProductListConstants.cardAspectRatio, contentMode: .fit)
        .cornerRadius(ProductListConstants.cardCornerRadius)
        .clipped()
    }
}

// MARK: - Subviews

private extension ProductCardView {
    var gradientOverlay: some View {
        // Vertical gradient improving text contrast on top and bottom areas
        LinearGradient(
            gradient: Gradient(colors: [
                Color.black.opacity(ProductListConstants.gradientTopOpacity),
                Color.clear,
                Color.black.opacity(ProductListConstants.gradientBottomOpacity)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    var contentOverlay: some View {
        // Foreground content layered over the image and gradient
        VStack(alignment: .leading) {
            header
            Spacer()
            quantityAndPriceBar
        }
    }

    var header: some View {
        // Product name and current selected quantity
        VStack(alignment: .leading, spacing: ProductListConstants.headerSpacing) {
            Text(product.name)
                .font(ProductListConstants.productTitleFont)
                .fontWeight(ProductListConstants.productTitleFontWeight)
                .foregroundColor(ProductListConstants.productTitleColor)
                .lineLimit(ProductListConstants.productTitleLineLimit)

            Text("\(product.quantity) \(ProductListConstants.units)")
                .font(.subheadline)
                .foregroundColor(ProductListConstants.quantityTitleColor)
        }
        .padding(ProductListConstants.headerPadding)
    }

    var quantityAndPriceBar: some View {
        // Bottom row: quantity controls on the left, price badge on the right
        HStack(spacing: ProductListConstants.bottomBarSpacing) {
            QuantityBar(
                quantity: product.quantity,
                onQuantityChange: { newQuantity in
                    onQuantityChange(product.id, newQuantity)
                }
            )
            Spacer()
            PriceBadge(product: product, selectedCurrency: selectedCurrency)
        }
        .padding(ProductListConstants.bottomBarPadding)
    }

}
