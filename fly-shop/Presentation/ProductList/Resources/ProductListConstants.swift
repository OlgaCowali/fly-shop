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
    static let maxProductQuantity: Int = 10

    // Bottom bar
    static let bottomBarSpacing: CGFloat = 12
    static let bottomBarPadding: CGFloat = 10
    static let buttonsForegroundColor: Color = .white
    
    // Icons
    static let plusButtonName = "plus"
    static let minusButtonName = "minus"

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

    // MARK: - Category Filter
    
    // Text
    static let filterPrefixText: String = "Filter:"
    static let allProductsText: String = "All Products"
    static let selectCategoryTitle: String = "Select Category"
    
    // Typography
    static let filterTextFont: Font = .callout
    static let filterIconFont: Font = .caption
    
    // Colors
    static let filterTextColor: Color = .black.opacity(0.7)
    static let filterIconColor: Color = .black.opacity(0.7)
    static let filterBackgroundColor: Color = .gray.opacity(0.3)
    
    // Layout
    static let filterHorizontalPadding: CGFloat = 12
    static let filterVerticalPadding: CGFloat = 8
    static let filterCornerRadius: CGFloat = 20
    
    // Icons
    static let filterDropdownIcon: String = "arrowtriangle.down.fill"
    
    // MARK: - Payment Section
    
    // Layout
    static let paymentCornerRadius: CGFloat = 30
    static let paymentButtonHeight: CGFloat = 60
    static let paymentPayButtonWidthRatio: CGFloat = 2/3
    static let paymentCustomerTypeButtonWidthRatio: CGFloat = 1/3
    static let paymentVerticalSpacing: CGFloat = 12
    static let paymentHorizontalPadding: CGFloat = 16
    static let paymentTopPadding: CGFloat = 20
    static let paymentBottomPadding: CGFloat = 20
    
    // Colors
    static let paymentPayButtonBackground: Color = .blue
    static let paymentCustomerTypeButtonBackground: Color = Color(red: 0.29, green: 0.33, blue: 0.38)
    static let paymentTextColor: Color = .white
    
    // Text
    static let paymentActionSheetTitle: String = "Select Customer Type"
    static let paymentActionSheetCancel: String = "Cancel"
    static let currencyDivider: String = "|"
    static let payButtonTitle: String = "PAY"
}
