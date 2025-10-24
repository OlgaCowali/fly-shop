//
//  CommonConstants.swift
//  fly-shop
//
//  Created by Olga Covaliova on 23.10.2025.
//

import SwiftUI

enum CommonConstants {
    
    // MARK: - Error State View
    
    // Layout
    static let errorStateSpacing: CGFloat = 20
    static let errorStatePadding: CGFloat = 16
    static let errorMessageHorizontalPadding: CGFloat = 20
    
    // Typography
    static let errorIconFont: Font = .system(size: 48)
    static let errorTitleFont: Font = .title2
    static let errorTitleFontWeight: Font.Weight = .bold
    static let errorMessageFont: Font = .body
    static let emptyScreenFont: Font = .title2
    
    // Colors
    static let errorIconColor: Color = .red
    static let errorTitleColor: Color = .primary
    static let errorMessageColor: Color = .secondary
    
    // Text
    static let errorTitle: String = "Something went wrong"
    static let retryButtonTitle: String = "Try Again"
    
    // Error Messages
    static let networkErrorMessage: String = "Please check your internet connection and try again."
    static let serverErrorMessage: String = "Server error occurred. Please try again later."
    static let decodingErrorMessage: String = "Unable to process the data. Please try again."
    static let notFoundErrorMessage: String = "The requested information was not found."
    static let unauthorizedErrorMessage: String = "You are not authorized to access this information."
    static let genericErrorMessage: String = "An unexpected error occurred. Please try again."
    
    // Icons
    static let errorIcon: String = "exclamationmark.triangle"
    
    // MARK: - Loading State View
    
    // Layout
    static let loadingStateSpacing: CGFloat = 20
    static let loadingStatePadding: CGFloat = 16
    
    // Typography
    static let loadingTextFont: Font = .body
    static let loadingTextColor: Color = .secondary
    
    // Colors
    static let loadingIndicatorColor: Color = .blue
    
    // Visual
    static let loadingIndicatorScale: CGFloat = 1.2
    
    // MARK: - Empty State View
    
    // Typography
    static let emptyStateFont: Font = .title2
    static let emptyStateTextColor: Color = .secondary
    
}
