//
//  CartView.swift
//  fly-shop
//
//  Created by Olga Covaliova on 20.10.2025.
//

import SwiftUI
// Uses constants defined in CartConstants

struct CartView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: CartViewViewModel
    
    init(
        viewModel: CartViewViewModel
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header section with Receipt title and close button
                CartHeaderView {
                    viewModel.dismiss()
                    dismiss()
                }
                .background(CartConstants.headerBackgroundColor)
                
                // Products list, empty state, or error state
                contentView
                
                // Bottom section with seat, total, and payment options
                CartBottomSectionView(
                    selectedSeat: $viewModel.selectedSeat,
                    totalAmount: PriceFormatter.formatPrice(price: viewModel.totalAmount, currency: viewModel.selectedCurrency) ?? "0.00 $",
                    onCashPayment: {
                        viewModel.showCashPayment()
                    },
                    onCardPayment: {
                        viewModel.showCardPayment()
                    }
                )
            }
            .navigationBarHidden(true)
        }
        .alert(CartConstants.emptyCartAlertTitle, isPresented: $viewModel.showEmptyCartAlert) {
            Button(CartConstants.emptyCartAlertButton, role: .cancel) { }
        } message: {
            Text(CartConstants.emptyCartAlertMessage)
        }
        .alert(CartConstants.paymentSuccessAlertTitle, isPresented: $viewModel.showPaymentSuccessAlert) {
            Button(CartConstants.paymentSuccessAlertButton, role: .cancel) {
                viewModel.handleSuccessAlertDismissal()
                dismiss()
            }
        } message: {
            Text(CartConstants.paymentSuccessAlertMessage)
        }
        .overlay(
            // Payment Modals
            Group {
                // Cash Payment Modal
                if viewModel.showCashPaymentView,
                   let cashPaymentViewModel = viewModel.cashPaymentViewModel {
                    CashPaymentView(
                        isPresented: $viewModel.showCashPaymentView,
                        onPaymentSuccess: {
                            viewModel.handlePaymentSuccess()
                        },
                        viewModel: cashPaymentViewModel
                    )
                    .transition(.opacity.combined(with: .scale(scale: CartConstants.cashPaymentModalScale)))
                }
                
                // Card Payment Modal
                if viewModel.showCardPaymentView,
                   let cardPaymentViewModel = viewModel.cardPaymentViewModel {
                    CardPaymentView(
                        isPresented: $viewModel.showCardPaymentView,
                        onPaymentSuccess: {
                            viewModel.handlePaymentSuccess()
                        },
                        viewModel: cardPaymentViewModel
                    )
                    .transition(.opacity.combined(with: .scale(scale: CartConstants.cardPaymentModalScale)))
                }
            }
        )
        .animation(.easeInOut(duration: CartConstants.cashPaymentModalAnimationDuration), value: viewModel.showCashPaymentView)
        .animation(.easeInOut(duration: CartConstants.cardPaymentModalAnimationDuration), value: viewModel.showCardPaymentView)
    }
    
    // MARK: - Private Views
    
    private var contentView: some View {
        switch viewModel.state {
        case .error(let error):
            AnyView(ErrorStateView(
                error: error,
                onRetry: {
                    viewModel.retry()
                }
            ))
        case .empty:
            AnyView(EmptyStateView(
                message: CartConstants.emptyCartMessage,
                font: CommonConstants.emptyScreenFont
            ))
        case .loaded:
            AnyView(CartProductListView(
                selectedProducts: viewModel.selectedProducts,
                viewModel: viewModel
            ))
        case .loading:
            AnyView(LoadingStateView(
                loadingText: CartConstants.loadingText,
                spacing: CommonConstants.loadingStateSpacing,
                padding: CommonConstants.loadingStatePadding,
                indicatorColor: CommonConstants.loadingIndicatorColor,
                indicatorScale: CommonConstants.loadingIndicatorScale,
                textFont: CommonConstants.loadingTextFont,
                textColor: CommonConstants.loadingTextColor
            ))
        }
    }
}
