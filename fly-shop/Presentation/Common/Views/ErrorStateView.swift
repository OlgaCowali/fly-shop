//
//  ErrorStateView.swift
//  fly-shop
//
//  Created by Olga Covaliova on 23.10.2025.
//

import SwiftUI

// A common view that displays when there's an error loading data
// Shows an error message with retry functionality
struct ErrorStateView: View {
    let error: DomainError
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: CommonConstants.errorStateSpacing) {
            Spacer()
            
            // Error icon
            Image(systemName: CommonConstants.errorIcon)
                .font(CommonConstants.errorIconFont)
                .foregroundColor(CommonConstants.errorIconColor)
            
            // Error title
            Text(CommonConstants.errorTitle)
                .font(CommonConstants.errorTitleFont)
                .fontWeight(CommonConstants.errorTitleFontWeight)
                .foregroundColor(CommonConstants.errorTitleColor)
            
            // Error message
            Text(errorMessage)
                .font(CommonConstants.errorMessageFont)
                .foregroundColor(CommonConstants.errorMessageColor)
                .multilineTextAlignment(.center)
                .padding(.horizontal, CommonConstants.errorMessageHorizontalPadding)
            
            // Retry button
            Button(CommonConstants.retryButtonTitle, action: onRetry)
                .buttonStyle(.borderedProminent)
            
            Spacer()
        }
        .padding(CommonConstants.errorStatePadding)
    }
    
    private var errorMessage: String {
        switch error {
        case .network:
            return CommonConstants.networkErrorMessage
        case .server:
            return CommonConstants.serverErrorMessage
        case .decoding:
            return CommonConstants.decodingErrorMessage
        case .notFound:
            return CommonConstants.notFoundErrorMessage
        case .unauthorized:
            return CommonConstants.unauthorizedErrorMessage
        case .generic:
            return CommonConstants.genericErrorMessage
        }
    }
}
