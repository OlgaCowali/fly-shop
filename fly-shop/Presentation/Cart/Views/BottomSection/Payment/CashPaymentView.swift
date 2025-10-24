//
//  CashPaymentView.swift
//  fly-shop
//
//  Created by Olga Covaliova on 20.10.2025.
//

import SwiftUI

struct CashPaymentView: View {
    @Binding var isPresented: Bool
    let onPaymentSuccess: (() -> Void)?
    @ObservedObject var viewModel: CashPaymentViewModel
    
    init(
        isPresented: Binding<Bool>,
        onPaymentSuccess: (() -> Void)? = nil,
        viewModel: CashPaymentViewModel
    ) {
        self._isPresented = isPresented
        self.onPaymentSuccess = onPaymentSuccess
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            // Background overlay
            Color.black.opacity(CartConstants.cashPaymentBackgroundOverlayOpacity)
                .ignoresSafeArea()
                .onTapGesture {
                    dismissView()
                }
            
            // Payment modal
            VStack(spacing: CartConstants.cashPaymentModalSpacing) {
                headerView
                amountInputView
                changeCalculationView
                errorMessageView
                actionButtonsView
            }
            .padding(CartConstants.cashPaymentModalPadding)
            .background(
                RoundedRectangle(cornerRadius: CartConstants.cashPaymentModalCornerRadius)
                    .fill(CartConstants.cashPaymentModalBackground)
                    .shadow(radius: CartConstants.cashPaymentModalShadowRadius, x: CartConstants.cashPaymentModalShadowOffsetX, y: CartConstants.cashPaymentModalShadowOffsetY)
            )
            .padding(.horizontal, CartConstants.cashPaymentModalHorizontalPadding)
        }
    }
    
    // MARK: - Sub-views
    
    private var headerView: some View {
        VStack(spacing: 8) {
            Text(CartConstants.cashPaymentTitle)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(CartConstants.cashPaymentSubtitle)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    private var amountInputView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(CartConstants.amountPaidLabel)
                .font(.headline)
                .foregroundColor(.primary)
            
            HStack {
                Text(viewModel.currency.symbol)
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                TextField(CartConstants.defaultAmountPlaceholder, text: $viewModel.enteredAmount)
                    .font(.title2)
                    .fontWeight(.medium)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(PlainTextFieldStyle())
                    .onChange(of: viewModel.enteredAmount) { newValue in
                        viewModel.validateAmount(newValue)
                    }
            }
            .padding(CartConstants.cashPaymentInputPadding)
            .background(
                RoundedRectangle(cornerRadius: CartConstants.cashPaymentInputCornerRadius)
                    .fill(CartConstants.cashPaymentInputBackground)
            )
        }
    }
    
    private var changeCalculationView: some View {
        VStack(spacing: 16) {
            // Total amount row
            HStack {
                Text(CartConstants.totalLabel)
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
                Text(viewModel.formattedTotal)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
            
            // Amount paid row
            HStack {
                Text(CartConstants.amountPaidLabel)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Text(viewModel.enteredAmount.isEmpty ? CartConstants.defaultAmountValue : viewModel.formattedAmountPaid)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }
            
            Divider()
            
            // Change row
            HStack {
                Text(CartConstants.changeLabel)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(viewModel.changeAmount >= 0 ? CartConstants.cashPaymentChangePositiveColor : CartConstants.cashPaymentChangeNegativeColor)
                Spacer()
                Text(viewModel.formattedChange)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(viewModel.changeAmount >= 0 ? CartConstants.cashPaymentChangePositiveColor : CartConstants.cashPaymentChangeNegativeColor)
            }
        }
        .padding(CartConstants.cashPaymentCalculationPadding)
        .background(
            RoundedRectangle(cornerRadius: CartConstants.cashPaymentCalculationCornerRadius)
                .fill(CartConstants.cashPaymentCalculationBackground)
        )
    }
    
    private var errorMessageView: some View {
        Group {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, CartConstants.cashPaymentErrorMessageHorizontalPadding)
            }
        }
    }
    
    private var actionButtonsView: some View {
        HStack(spacing: CartConstants.cashPaymentButtonSpacing) {
            // Cancel button
            Button(action: dismissView) {
                Text(CartConstants.cancelButtonText)
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, CartConstants.cashPaymentButtonPadding)
                    .background(
                        RoundedRectangle(cornerRadius: CartConstants.cashPaymentButtonCornerRadius)
                            .fill(CartConstants.cashPaymentCancelButtonBackground)
                    )
            }
            
            // Confirm button
            Button(action: confirmPayment) {
                HStack {
                    if viewModel.isProcessing {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(CartConstants.cashPaymentProgressViewScale)
                    }
                    Text(CartConstants.confirmPaymentButtonText)
                        .font(.headline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, CartConstants.cashPaymentButtonPadding)
                .background(
                    RoundedRectangle(cornerRadius: CartConstants.cashPaymentButtonCornerRadius)
                        .fill(viewModel.isValidAmount ? CartConstants.cashPaymentConfirmButtonBackground : CartConstants.cashPaymentConfirmButtonDisabledBackground)
                )
            }
            .disabled(!viewModel.isValidAmount || viewModel.isProcessing)
        }
    }
    
    // MARK: - Actions
    
    private func confirmPayment() {
        Task {
            let result = await viewModel.processPayment()
            if result.isSuccess {
                onPaymentSuccess?()
                dismissView()
            }
        }
    }
    
    private func dismissView() {
        withAnimation(.easeInOut(duration: CartConstants.cashPaymentModalAnimationDuration)) {
            isPresented = false
        }
    }
}

