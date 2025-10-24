//
//  CardPaymentView.swift
//  fly-shop
//
//  Created by Olga Covaliova on 20.10.2025.
//

import SwiftUI

struct CardPaymentView: View {
    @Binding var isPresented: Bool
    let onPaymentSuccess: () -> Void
    
    @StateObject private var viewModel: CardPaymentViewModel
    
    init(isPresented: Binding<Bool>, onPaymentSuccess: @escaping () -> Void, viewModel: CardPaymentViewModel) {
        self._isPresented = isPresented
        self.onPaymentSuccess = onPaymentSuccess
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            // Background overlay
            Color.black
                .opacity(CartConstants.cardPaymentBackgroundOverlayOpacity)
                .ignoresSafeArea()
                .onTapGesture {
                    if !viewModel.isProcessing {
                        isPresented = false
                    }
                }
            
            // Modal content
            VStack(spacing: CartConstants.cardPaymentModalSpacing) {
                // Header
                VStack(spacing: CartConstants.cardPaymentHeaderSpacing) {
                    Text(CartConstants.cardPaymentTitle)
                        .font(CartConstants.cardPaymentTitleFont)
                        .fontWeight(CartConstants.cardPaymentTitleFontWeight)
                        .foregroundColor(CartConstants.cardPaymentTitleColor)
                    
                    Text(CartConstants.cardPaymentSubtitle)
                        .font(CartConstants.cardPaymentSubtitleFont)
                        .foregroundColor(CartConstants.cardPaymentSubtitleColor)
                }
                .padding(.top, CartConstants.cardPaymentModalPadding)
                
                // Form fields
                VStack(spacing: CartConstants.cardPaymentFieldSpacing) {
                    // Card Number
                    VStack(alignment: .leading, spacing: CartConstants.cardPaymentLabelSpacing) {
                        Text(CartConstants.cardNumberLabel)
                            .font(CartConstants.cardPaymentLabelFont)
                            .fontWeight(CartConstants.cardPaymentLabelFontWeight)
                            .foregroundColor(CartConstants.cardPaymentLabelColor)
                        
                        TextField(CartConstants.cardNumberPlaceholder, text: $viewModel.cardNumber)
                            .font(CartConstants.cardPaymentInputFont)
                            .keyboardType(.numberPad)
                            .textFieldStyle(CardPaymentTextFieldStyle())
                            .onChange(of: viewModel.cardNumber) { _, newValue in
                                viewModel.validateCardNumber(newValue)
                            }
                    }
                    
                    // Expiration Date and CVV
                    HStack(spacing: CartConstants.cardPaymentFieldSpacing) {
                        // Expiration Date
                        VStack(alignment: .leading, spacing: CartConstants.cardPaymentLabelSpacing) {
                            Text(CartConstants.expirationDateLabel)
                                .font(CartConstants.cardPaymentLabelFont)
                                .fontWeight(CartConstants.cardPaymentLabelFontWeight)
                                .foregroundColor(CartConstants.cardPaymentLabelColor)
                            
                            TextField(CartConstants.expirationDatePlaceholder, text: $viewModel.expirationDate)
                                .font(CartConstants.cardPaymentInputFont)
                                .keyboardType(.numberPad)
                                .textFieldStyle(CardPaymentTextFieldStyle())
                                .onChange(of: viewModel.expirationDate) { _, newValue in
                                    viewModel.validateExpirationDate(newValue)
                                }
                        }
                        
                        // CVV
                        VStack(alignment: .leading, spacing: CartConstants.cardPaymentLabelSpacing) {
                            Text(CartConstants.cvvLabel)
                                .font(CartConstants.cardPaymentLabelFont)
                                .fontWeight(CartConstants.cardPaymentLabelFontWeight)
                                .foregroundColor(CartConstants.cardPaymentLabelColor)
                            
                            TextField(CartConstants.cvvPlaceholder, text: $viewModel.cvv)
                                .font(CartConstants.cardPaymentInputFont)
                                .keyboardType(.numberPad)
                                .textFieldStyle(CardPaymentTextFieldStyle())
                                .onChange(of: viewModel.cvv) { _, newValue in
                                    viewModel.validateCVV(newValue)
                                }
                        }
                    }
                    
                    // Cardholder Name
                    VStack(alignment: .leading, spacing: CartConstants.cardPaymentLabelSpacing) {
                        Text(CartConstants.cardholderNameLabel)
                            .font(CartConstants.cardPaymentLabelFont)
                            .fontWeight(CartConstants.cardPaymentLabelFontWeight)
                            .foregroundColor(CartConstants.cardPaymentLabelColor)
                        
                        TextField(CartConstants.cardholderNamePlaceholder, text: $viewModel.cardholderName)
                            .font(CartConstants.cardPaymentInputFont)
                            .textFieldStyle(CardPaymentTextFieldStyle())
                            .onChange(of: viewModel.cardholderName) { _, newValue in
                                viewModel.validateCardholderName(newValue)
                            }
                    }
                }
                .padding(.horizontal, CartConstants.cardPaymentModalHorizontalPadding)
                
                // Error message
                if let errorMessage = viewModel.errorMessage, !errorMessage.isEmpty {
                    Text(errorMessage)
                        .font(CartConstants.cardPaymentErrorMessageFont)
                        .foregroundColor(CartConstants.cardPaymentErrorMessageColor)
                        .padding(.horizontal, CartConstants.cardPaymentErrorMessageHorizontalPadding)
                }
                
                // Action buttons
                HStack(spacing: CartConstants.cardPaymentButtonSpacing) {
                    // Cancel button
                    Button(action: {
                        if !viewModel.isProcessing {
                            isPresented = false
                        }
                    }) {
                        Text(CartConstants.cancelButtonText)
                            .font(CartConstants.cardPaymentButtonFont)
                            .fontWeight(CartConstants.cardPaymentButtonFontWeight)
                            .foregroundColor(CartConstants.cardPaymentCancelButtonTextColor)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, CartConstants.cardPaymentButtonPadding)
                            .background(
                                RoundedRectangle(cornerRadius: CartConstants.cardPaymentButtonCornerRadius)
                                    .fill(CartConstants.cardPaymentCancelButtonBackground)
                            )
                    }
                    .disabled(viewModel.isProcessing)
                    
                    // Confirm payment button
                    Button(action: {
                        Task {
                            await processPayment()
                        }
                    }) {
                        HStack {
                            if viewModel.isProcessing {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(CartConstants.cardPaymentProgressViewScale)
                            }
                            
                            Text(viewModel.isProcessing ? CartConstants.processingPaymentText : CartConstants.confirmPaymentButtonText)
                                .font(CartConstants.cardPaymentButtonFont)
                                .fontWeight(CartConstants.cardPaymentButtonFontWeight)
                                .foregroundColor(CartConstants.cardPaymentConfirmButtonTextColor)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, CartConstants.cardPaymentButtonPadding)
                        .background(
                            RoundedRectangle(cornerRadius: CartConstants.cardPaymentButtonCornerRadius)
                                .fill(viewModel.isFormValid ? CartConstants.cardPaymentConfirmButtonBackground : CartConstants.cardPaymentConfirmButtonDisabledBackground)
                        )
                    }
                    .disabled(!viewModel.isFormValid || viewModel.isProcessing)
                }
                .padding(.horizontal, CartConstants.cardPaymentModalHorizontalPadding)
                .padding(.bottom, CartConstants.cardPaymentModalPadding)
            }
            .background(
                RoundedRectangle(cornerRadius: CartConstants.cardPaymentModalCornerRadius)
                    .fill(CartConstants.cardPaymentModalBackground)
                    .shadow(
                        color: CartConstants.cardPaymentModalShadowColor,
                        radius: CartConstants.cardPaymentModalShadowRadius,
                        x: CartConstants.cardPaymentModalShadowOffsetX,
                        y: CartConstants.cardPaymentModalShadowOffsetY
                    )
            )
            .padding(.horizontal, CartConstants.cardPaymentModalHorizontalPadding)
        }
        .animation(.easeInOut(duration: CartConstants.cardPaymentModalAnimationDuration), value: isPresented)
    }
    
    // MARK: - Private Methods
    
    private func processPayment() async {
        let result = await viewModel.processPayment()
        
        if result.isSuccess {
            onPaymentSuccess()
            isPresented = false
        }
        // Error is already handled in the ViewModel
    }
}

// MARK: - Custom TextField Style

struct CardPaymentTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(CartConstants.cardPaymentInputPadding)
            .background(
                RoundedRectangle(cornerRadius: CartConstants.cardPaymentInputCornerRadius)
                    .fill(CartConstants.cardPaymentInputBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: CartConstants.cardPaymentInputCornerRadius)
                    .stroke(CartConstants.cardPaymentInputBorderColor, lineWidth: CartConstants.cardPaymentInputBorderWidth)
            )
    }
}
