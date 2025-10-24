//
//  CartConstants.swift
//  fly-shop
//
//  Created by Olga Covaliova on 23.10.2025.
//

import SwiftUI

enum CartConstants {
    
    // MARK: - CartHeaderView
    
    // Text
    static let receiptTitle: String = "Receipt"
    static let selectedProductsSubtitle: String = "Selected Products"
    
    // Typography
    static let receiptTitleFont: Font = .largeTitle
    static let receiptTitleFontWeight: Font.Weight = .bold
    static let subtitleFont: Font = .subheadline
    static let closeButtonFont: Font = .headline
    
    // Layout
    static let headerVerticalSpacing: CGFloat = 4
    static let horizontalPadding: CGFloat = 16
    static let topPadding: CGFloat = 20
    static let bottomPadding: CGFloat = 16
    
    // Size
    static let closeButtonFrame: CGFloat = 46
    
    
    // Icons
    static let closeButton: String = "xmark"
    
    // Colors
    static let headerBackgroundColor = Color(.systemBackground)
    static let closeButtonBackgroundColor = Color.gray.opacity(0.15)
    
    // MARK: - CartProductListView
    
    // Layout
    static let productListSpacing: CGFloat = 12
    static let listRowTopInset: CGFloat = 0
    
    // Colors
    static let mainViewBackgroundColor = Color.gray.opacity(0.15)
    
    // Text
    static let deleteActionText: String = "Delete"
    
    // Icons
    static let deleteActionIcon: String = "trash"
    
    // MARK: - CartEmptyStateView
    
    // Text
    static let emptyCartMessage: String = "Your cart is empty"
    
    // MARK: - Empty Cart Alert
    
    // Text
    static let emptyCartAlertTitle: String = "Cart is Empty"
    static let emptyCartAlertMessage: String = "Please add some products to your cart before proceeding to payment."
    static let emptyCartAlertButton: String = "OK"
    
    // MARK: - Payment Success Alert
    
    // Text
    static let paymentSuccessAlertTitle: String = "Payment Successful"
    static let paymentSuccessAlertMessage: String = "Your payment has been processed successfully. Thank you for your purchase!"
    static let paymentSuccessAlertButton: String = "OK"
    
    // MARK: - LoadingStateView
    
    // Text
    static let loadingText: String = "Loading cart..."

    // MARK: - CartProductRow
    
    // Typography
    static let productNameFont: Font = .headline
    static let productPriceFont: Font = .callout
    static let quantityFont: Font = .headline
    
    // Layout
    static let productInfoSpacing: CGFloat = 4
    static let productRowPadding: CGFloat = 6
    static let productRowSidePadding: CGFloat = 8
    
    // Size
    static let productImageSize: CGFloat = 70
    
    // Visual
    static let cornerRadius: CGFloat = 16
    static let shadowRadius: CGFloat = 8
    static let shadowOffsetY: CGFloat = 2
    static let shadowOpacity: Double = 0.05
    static let imageBackgroundOpacity: Double = 0.3
    
    // Icons
    static let placeholderImage: String = "photo"
    
    // MARK: - Cart Bottom Section
    
    // Text
    static let seatLabel: String = "SEAT"
    static let totalLabel: String = "TOTAL"
    static let cashButtonText: String = "Cash"
    static let cardButtonText: String = "Card"
    
    // Layout - CartBottomSectionView specific
    static let seatSectionLeadingPadding: CGFloat = 7
    
    // Typography
    static let labelFont: Font = .caption
    static let labelFontWeight: Font.Weight = .medium
    static let totalAmountFont: Font = .title2
    static let totalAmountFontWeight: Font.Weight = .bold
    static let seatNumberFont: Font = .subheadline
    static let seatNumberFontWeight: Font.Weight = .medium
    static let buttonTextFont: Font = .subheadline
    static let buttonTextFontWeight: Font.Weight = .medium
    static let buttonIconFont: Font = .title2
    
    // Layout
    static let bottomSectionSpacing: CGFloat = 20
    static let seatSectionSpacing: CGFloat = 8
    static let totalSectionSpacing: CGFloat = 4
    static let paymentButtonsSpacing: CGFloat = 16
    static let buttonContentSpacing: CGFloat = 8
    static let buttonVerticalPadding: CGFloat = 16
    static let bottomSectionBottomPadding: CGFloat = 20
    static let bottomSectionHorizontalPadding: CGFloat = 16
    
    // Size
    static let seatFrameWidth: CGFloat = 50
    static let seatFrameHeight: CGFloat = 30
    
    // Visual
    static let seatBackgroundOpacity: Double = 0.2
    static let seatCornerRadius: CGFloat = 8
    static let buttonCornerRadius: CGFloat = 12
    
    // Icons
    static let cashButtonIcon: String = "wallet.bifold.fill"
    static let cardButtonIcon: String = "creditcard.fill"
    
    // Colors
    static let cashButtonBackgroundColor = Color(red: 0.20, green: 0.20, blue: 0.20)
    static let cardButtonBackgroundColor = Color(red: 0.20, green: 0.46, blue: 0.96)
    static let buttonTextColor = Color(red: 0.96, green: 0.94, blue: 0.90)
    
    // MARK: - Seat Selection
    
    // Seat data
    static let seatRows = ["A", "B", "C", "D", "E", "F"]
    static let seatNumbers = Array(1...6)
    
    // Dropdown styling
    static let dropdownCornerRadius: CGFloat = 8
    static let dropdownBackgroundOpacity: Double = 0.95
    static let dropdownItemHeight: CGFloat = 44
    static let dropdownMaxHeight: CGFloat = 200
    static let dropdownShadowRadius: CGFloat = 4
    static let dropdownShadowOpacity: Double = 0.1
    
    
    // MARK: - SeatSectionView Additional Constants
    
    // Padding
    static let seatButtonHorizontalPadding: CGFloat = 8
    static let seatButtonVerticalPadding: CGFloat = 6
    static let seatOptionHorizontalPadding: CGFloat = 8
    static let seatOptionVerticalPadding: CGFloat = 6
    
    // Animation
    static let dropdownAnimationDuration: Double = 0.2
    static let dropdownAnimationScale: CGFloat = 0.95
    
    // Colors
    static let selectedSeatBackgroundColor = Color.blue.opacity(0.1)
    static let dropdownShadowColor = Color.black
    
    // Shadow
    static let dropdownShadowOffsetX: CGFloat = 0
    static let dropdownShadowOffsetY: CGFloat = 2
    
    // MARK: - CashPaymentView
    
    // Text
    static let cashPaymentTitle: String = "Cash Payment"
    static let cashPaymentSubtitle: String = "Enter the amount you're paying"
    static let amountPaidLabel: String = "Amount Paid"
    static let changeLabel: String = "Change:"
    static let cancelButtonText: String = "Cancel"
    static let confirmPaymentButtonText: String = "Confirm Payment"
    static let defaultAmountPlaceholder: String = "0.00"
    static let defaultAmountValue: String = "0.00"
    
    // Layout
    static let cashPaymentModalSpacing: CGFloat = 24
    static let cashPaymentModalPadding: CGFloat = 24
    static let cashPaymentModalHorizontalPadding: CGFloat = 32
    static let cashPaymentModalCornerRadius: CGFloat = 16
    static let cashPaymentInputPadding: CGFloat = 16
    static let cashPaymentInputCornerRadius: CGFloat = 12
    static let cashPaymentCalculationPadding: CGFloat = 16
    static let cashPaymentCalculationCornerRadius: CGFloat = 12
    static let cashPaymentButtonSpacing: CGFloat = 16
    static let cashPaymentButtonPadding: CGFloat = 16
    static let cashPaymentButtonCornerRadius: CGFloat = 12
    
    // Animation
    static let cashPaymentModalAnimationDuration: Double = 0.3
    static let cashPaymentModalScale: CGFloat = 0.9
    
    // Colors
    static let cashPaymentModalBackground = Color(.systemBackground)
    static let cashPaymentInputBackground = Color(.systemGray6)
    static let cashPaymentCalculationBackground = Color(.systemGray6)
    static let cashPaymentCancelButtonBackground = Color(.systemGray5)
    static let cashPaymentConfirmButtonBackground = Color.blue
    static let cashPaymentConfirmButtonDisabledBackground = Color.gray
    static let cashPaymentChangePositiveColor = Color.green
    static let cashPaymentChangeNegativeColor = Color.red
    
    // MARK: - CashPaymentViewModel Error Messages
    
    // Error messages
    static let invalidPaymentAmountMessage: String = "Invalid payment amount"
    static let invalidAmountFormatMessage: String = "Invalid amount format"
    static let paymentProcessingFailedMessage: String = "Payment processing failed:"
    static let paymentFailedMessage: String = "Payment failed"
    
    // MARK: - CashPaymentService Constants
    
    // Processing
    static let paymentProcessingDelayNanoseconds: UInt64 = 1_000_000_000 // 1 second
    
    // Messages
    static let insufficientPaymentAmountMessage: String = "Insufficient payment amount"
    static let paymentProcessedSuccessfullyMessage: String = "Payment processed successfully"
    
    // MARK: - CashPaymentView Constants
    
    // Background overlay
    static let cashPaymentBackgroundOverlayOpacity: Double = 0.4
    
    // Shadow
    static let cashPaymentModalShadowRadius: CGFloat = 20
    static let cashPaymentModalShadowOffsetX: CGFloat = 0
    static let cashPaymentModalShadowOffsetY: CGFloat = 10
    
    // Progress view
    static let cashPaymentProgressViewScale: CGFloat = 0.8
    
    // Error message
    static let cashPaymentErrorMessageHorizontalPadding: CGFloat = 16
    
    // MARK: - CardPaymentView
    
    // Text
    static let cardPaymentTitle: String = "Card Payment"
    static let cardPaymentSubtitle: String = "Enter your card details"
    static let cardNumberLabel: String = "Card Number"
    static let cardNumberPlaceholder: String = "1234 5678 9012 3456"
    static let expirationDateLabel: String = "Expiration Date"
    static let expirationDatePlaceholder: String = "MM/YY"
    static let cvvLabel: String = "CVV"
    static let cvvPlaceholder: String = "123"
    static let cardholderNameLabel: String = "Cardholder Name"
    static let cardholderNamePlaceholder: String = "John Doe"
    static let processingPaymentText: String = "Processing..."
    static let invalidFormMessage: String = "Please fill in all fields correctly"
    
    // MARK: - CardPaymentService Error Messages
    
    // Error messages
    static let networkErrorMessage: String = "Network error. Please check your connection."
    static let serverUnavailableMessage: String = "Payment gateway is unavailable. Please try again."
    static let invalidResponseMessage: String = "Invalid response from payment gateway."
    static let authorizationFailedMessage: String = "Payment authorization failed."
    static let serviceNotFoundMessage: String = "Payment service not found."
    static let genericPaymentErrorMessage: String = "Payment processing failed. Please try again."
    
    // Dynamic error message helpers
    static func paymentFailedMessage(status: String, statusCode: Int) -> String {
        return "Payment failed with status: \(status) (code: \(statusCode))"
    }
    
    // Layout
    static let cardPaymentModalSpacing: CGFloat = 24
    static let cardPaymentModalPadding: CGFloat = 24
    static let cardPaymentModalHorizontalPadding: CGFloat = 32
    static let cardPaymentModalCornerRadius: CGFloat = 16
    static let cardPaymentHeaderSpacing: CGFloat = 8
    static let cardPaymentFieldSpacing: CGFloat = 20
    static let cardPaymentLabelSpacing: CGFloat = 8
    static let cardPaymentInputPadding: CGFloat = 16
    static let cardPaymentInputCornerRadius: CGFloat = 12
    static let cardPaymentButtonSpacing: CGFloat = 16
    static let cardPaymentButtonPadding: CGFloat = 16
    static let cardPaymentButtonCornerRadius: CGFloat = 12
    static let cardPaymentErrorMessageHorizontalPadding: CGFloat = 16
    
    // Animation
    static let cardPaymentModalAnimationDuration: Double = 0.3
    static let cardPaymentModalScale: CGFloat = 0.9
    
    // Typography
    static let cardPaymentTitleFont: Font = .largeTitle
    static let cardPaymentTitleFontWeight: Font.Weight = .bold
    static let cardPaymentSubtitleFont: Font = .subheadline
    static let cardPaymentLabelFont: Font = .caption
    static let cardPaymentLabelFontWeight: Font.Weight = .medium
    static let cardPaymentInputFont: Font = .body
    static let cardPaymentButtonFont: Font = .headline
    static let cardPaymentButtonFontWeight: Font.Weight = .medium
    static let cardPaymentErrorMessageFont: Font = .caption
    
    // Colors
    static let cardPaymentModalBackground = Color(.systemBackground)
    static let cardPaymentTitleColor = Color.primary
    static let cardPaymentSubtitleColor = Color.secondary
    static let cardPaymentLabelColor = Color.primary
    static let cardPaymentInputBackground = Color(.systemGray6)
    static let cardPaymentInputBorderColor = Color(.systemGray4)
    static let cardPaymentInputBorderWidth: CGFloat = 1
    static let cardPaymentCancelButtonBackground = Color(.systemGray5)
    static let cardPaymentCancelButtonTextColor = Color.primary
    static let cardPaymentConfirmButtonBackground = Color.blue
    static let cardPaymentConfirmButtonDisabledBackground = Color.gray
    static let cardPaymentConfirmButtonTextColor = Color.white
    static let cardPaymentErrorMessageColor = Color.red
    static let cardPaymentModalShadowColor = Color.black
    static let cardPaymentBackgroundOverlayOpacity: Double = 0.4
    
    // Shadow
    static let cardPaymentModalShadowRadius: CGFloat = 20
    static let cardPaymentModalShadowOffsetX: CGFloat = 0
    static let cardPaymentModalShadowOffsetY: CGFloat = 10
    
    // Progress view
    static let cardPaymentProgressViewScale: CGFloat = 0.8
}
