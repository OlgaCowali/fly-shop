//
//  ProductListConstants.swift
//  fly-shop
//
//  Created by Olga Covaliova on 20.10.2025.
//


import SwiftUI

enum ProductListConstants {
    // UI Text
    static let titleText: String = "Products"
    static let loadingText: String = "Loading products..."

    // Typography
    static let titleFont: Font = .title3
    static let titleFontWeight: Font.Weight = .semibold

    // Layout
    static let titleTopPadding: CGFloat = 16
    static let gridSpacing: CGFloat = 16
    static let contentPadding: CGFloat = 16

    // Grid Layout
    static let gridColumns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    // MARK: - Product Card
    // Layout
    static let cardAspectRatio: CGFloat = 0.85
    static let cardCornerRadius: CGFloat = 16

    // Header
    static let productTitleFont: Font = .headline
    static let productTitleFontWeight: Font.Weight = .bold
    static let productTitleColor: Color = .white
    static let productTitleLineLimit: Int = 2
    static let headerSpacing: CGFloat = 4
    static let headerPadding: CGFloat = 12
    static let units = "units"
    static let quantityTitleColor: Color = .white.opacity(0.9)

    // Quantity bar
    static let quantityBarSpacing: CGFloat = 12
    static let quantityButtonSize: CGFloat = 32
    static let quantityButtonIconFontSize: CGFloat = 13
    static let quantityButtonIconFontWeight: Font.Weight = .bold
    static let quantityMinusButtonBackground: Color = .red
    static let quantityPlusButtonBackground: Color = .blue
    static let quantityBarFrameWidth: CGFloat = 60

    // Bottom bar
    static let bottomBarSpacing: CGFloat = 12
    static let bottomBarPadding: CGFloat = 10
    static let plusButtonName = "plus"
    static let minusButtonName = "minus"
    static let buttonsForegroundColor: Color = .white

    // Price badge
    static let priceFont: Font = .subheadline
    static let priceFontWeight: Font.Weight = .bold
    static let priceTextColor: Color = .white
    static let priceBadgeHorizontalPadding: CGFloat = 8
    static let priceBadgeVerticalPadding: CGFloat = 6
    static let priceBadgeBackground: Color = Color.black.opacity(0.8)
    static let priceBadgeCornerRadius: CGFloat = 8
    static let priceCurrencySuffix: String = " $"

    // Gradient overlay
    static let gradientTopOpacity: CGFloat = 0.6
    static let gradientBottomOpacity: CGFloat = 0.4

    // Placeholder
    static let imagePlaceholderOpacity: CGFloat = 0.3

    // Formatting
    static let priceMinimumFractionDigits: Int = 2
    static let priceMaximumFractionDigits: Int = 2
}
