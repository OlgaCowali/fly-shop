//
//  CartViewViewModel.swift
//  fly-shop
//
//  Created by Olga Covaliova on 23.10.2025.
//

import SwiftUI
import Foundation
import Combine

@MainActor
final class CartViewViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var isDismissed = false
    @Published var selectedCurrency: Currency
    @Published var selectedSeat: String {
        didSet {
            sessionService.updateSeat(selectedSeat)
        }
    }
    @Published var showCashPaymentView = false
    @Published var showCardPaymentView = false
    @Published var showEmptyCartAlert = false
    @Published var showPaymentSuccessAlert = false
    
    // MARK: - Dependencies
    private let sessionService: CartSessionService
    private let paymentService: CashPaymentService
    private let cardPaymentService: CardPaymentService
    private let stateService: CartStateServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Payment ViewModels
    @Published private(set) var cashPaymentViewModel: CashPaymentViewModel?
    @Published private(set) var cardPaymentViewModel: CardPaymentViewModel?
    
    // MARK: - Computed Properties
    
    // Returns the current state from the state manager
    var state: ViewState {
        stateService.state
    }
    
    // Returns the current error from the state manager
    var error: DomainError? {
        stateService.error
    }
    
    // Returns the products from the cart service
    var selectedProducts: [Product] {
        sessionService.selectedProducts
    }
    
    // Returns the total amount for the selected currency
    var totalAmount: Decimal {
        let totals = CartCalculator.calculateTotals(for: selectedProducts, currencies: [selectedCurrency])
        return totals[selectedCurrency] ?? 0
    }
    
    // MARK: - Initialization
    
    init(
        selectedCurrency: Currency,
        sessionService: CartSessionService,
        paymentService: CashPaymentService,
        cardPaymentService: CardPaymentService,
        stateManager: CartStateServiceProtocol? = nil
    ) {
        self.selectedCurrency = selectedCurrency
        self.sessionService = sessionService
        self.paymentService = paymentService
        self.cardPaymentService = cardPaymentService
        self.stateService = stateManager ?? CartStateService()
        self.selectedSeat = sessionService.selectedSeat
        
        setupSessionServiceObservation()
        updateState()
    }
    
    // MARK: - Public Methods
    
    // Dismisses the cart view
    func dismiss() {
        isDismissed = true
    }
    
    // Removes a product from the cart
    func removeProduct(productId: UUID) {
        sessionService.removeProduct(productId: productId)
    }
    
    // Returns formatted total payment string for a specific product
    func formatTotalPayment(for product: Product) -> String? {
        let totalPayment = CartCalculator.calculateTotalPayment(for: product, currency: selectedCurrency)
        return PriceFormatter.formatPrice(price: totalPayment, currency: selectedCurrency)
    }
    
    // Retries loading cart data
    func retry() {
        stateService.clearError()
        updateState()
    }
    
    // Shows the cash payment view
    func showCashPayment() {
        guard !selectedProducts.isEmpty else {
            showEmptyCartAlert = true
            return
        }
        
        cashPaymentViewModel = CashPaymentViewModel(
            paymentService: paymentService,
            totalAmount: totalAmount,
            currency: selectedCurrency
        )
        showCashPaymentView = true
    }
    
    // Hides the cash payment view
    func hideCashPayment() {
        showCashPaymentView = false
        cashPaymentViewModel = nil
    }
    
    // Shows the card payment view
    func showCardPayment() {
        guard !selectedProducts.isEmpty else {
            showEmptyCartAlert = true
            return
        }
        
        cardPaymentViewModel = CardPaymentViewModel(
            paymentService: cardPaymentService,
            totalAmount: totalAmount,
            currency: selectedCurrency
        )
        showCardPaymentView = true
    }
    
    // Hides the card payment view
    func hideCardPayment() {
        showCardPaymentView = false
        cardPaymentViewModel = nil
    }
    
    // Handles successful payment completion
    func handlePaymentSuccess() {
        // Show success alert
        showPaymentSuccessAlert = true
    }
    
    // Called when user dismisses the success alert
    func handleSuccessAlertDismissal() {
        // Clear the cart
        sessionService.clearCart()
        // Dismiss the cart view
        dismiss()
    }
    
    // Returns the payment service for use in CashPaymentView
    func getPaymentService() -> CashPaymentService {
        return paymentService
    }
    
    // MARK: - Private Methods
    
    private func setupSessionServiceObservation() {
        // Observe changes to the session service to trigger UI updates using the protocol publisher
        sessionService.selectedProductsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateState()
            }
            .store(in: &cancellables)
    }
    
    // Updates the view state based on current cart content
    private func updateState() {
        stateService.updateState(products: selectedProducts)
    }
}
