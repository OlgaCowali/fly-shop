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
    @Binding var quantity: Int
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                backgroundImage(size: geometry.size)
                gradientOverlay
                contentOverlay
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

            Text("\(quantity) \(ProductListConstants.units)")
                .font(.subheadline)
                .foregroundColor(ProductListConstants.quantityTitleColor)
        }
        .padding(ProductListConstants.headerPadding)
    }

    var quantityAndPriceBar: some View {
        // Bottom row: quantity controls on the left, price badge on the right
        HStack(spacing: ProductListConstants.bottomBarSpacing) {
            quantityBar
            Spacer()
            priceBadge
        }
        .padding(ProductListConstants.bottomBarPadding)
    }

    var quantityBar: some View {
        // Increment/decrement controls. "-" is hidden when quantity is 0
        HStack(spacing: ProductListConstants.quantityBarSpacing) {
            if quantity > 0 {
                Button(action: { quantity = max(0, quantity - 1) }) {
                    Image(systemName: ProductListConstants.minusButtonName)
                        .font(.system(size: ProductListConstants.quantityButtonIconFontSize, weight: ProductListConstants.quantityButtonIconFontWeight))
                        .foregroundColor(ProductListConstants.buttonsForegroundColor)
                        .frame(width: ProductListConstants.quantityButtonSize, height: ProductListConstants.quantityButtonSize)
                        .background(ProductListConstants.quantityMinusButtonBackground)
                        .clipShape(Circle())
                }
            }

            Button(action: { quantity += 1 }) {
                Image(systemName: ProductListConstants.plusButtonName)
                    .font(.system(size: ProductListConstants.quantityButtonIconFontSize, weight: ProductListConstants.quantityButtonIconFontWeight))
                    .foregroundColor(ProductListConstants.buttonsForegroundColor)
                    .frame(width: ProductListConstants.quantityButtonSize, height: ProductListConstants.quantityButtonSize)
                    .background(ProductListConstants.quantityPlusButtonBackground)
                    .clipShape(Circle())
            }
        }
        .frame(width: ProductListConstants.quantityBarFrameWidth, alignment: .leading)
    }

    var priceBadge: some View {
        // Price display formatted to 2 decimals; shown only if USD price exists
        Group {
            if let price = product.prices[.usd], let formatted = Self.priceFormatter.string(from: NSDecimalNumber(decimal: price)) {
                Text("\(formatted)\(ProductListConstants.priceCurrencySuffix)")
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
    
    func backgroundImage(size: CGSize) -> some View {
        // Async image loading with simple placeholder, scaled to fill the card bounds
        AsyncImage(url: URL(string: product.imageURL)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height: size.height)
                .clipped()
        } placeholder: {
            Rectangle()
                .fill(Color.gray.opacity(ProductListConstants.imagePlaceholderOpacity))
        }
    }
}

// MARK: - Formatters

private extension ProductCardView {
    static let priceFormatter: NumberFormatter = {
        // Shared price formatter for consistent monetary display
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = ProductListConstants.priceMinimumFractionDigits
        formatter.maximumFractionDigits = ProductListConstants.priceMaximumFractionDigits
        return formatter
    }()
}
