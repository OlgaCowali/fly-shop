//
//  PaymentSectionView.swift
//  fly-shop
//
//  Created by Olga Covaliova on 20.10.2025.
//

import SwiftUI

struct PaymentSectionView: View {
    
    let totalAmount: Double
    let selectedCustomerType: CustomerType
    let customerTypes: [CustomerType]
    let onCustomerTypeChange: (CustomerType) -> Void
    let onPayButtonTapped: () -> Void
    
    @State private var isShowingCustomerTypeActionSheet = false
    
    var body: some View {
        VStack(spacing: ProductListConstants.paymentVerticalSpacing) {
            paymentButtonSection
            currencyConversionSection
        }
        .padding(.horizontal, ProductListConstants.paymentHorizontalPadding)
        .padding(.top, ProductListConstants.paymentTopPadding)
        .padding(.bottom, ProductListConstants.paymentBottomPadding)
        .actionSheet(isPresented: $isShowingCustomerTypeActionSheet) {
            customerTypeActionSheet
        }
    }
}

// MARK: - Subviews

private extension PaymentSectionView {
    
    var paymentButtonSection: some View {
        GeometryReader { geometry in
            ZStack {
                createBackgroundShape(geometry: geometry)
                createButtonOverlays(geometry: geometry)
            }
        }
        .frame(height: ProductListConstants.paymentButtonHeight)
    }
    
    func createBackgroundShape(geometry: GeometryProxy) -> some View {
        RoundedRectangle(cornerRadius: ProductListConstants.paymentCornerRadius)
            .fill(Color.clear)
            .overlay(createBackgroundGradient(geometry: geometry))
    }
    
    func createBackgroundGradient(geometry: GeometryProxy) -> some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(ProductListConstants.paymentPayButtonBackground)
                .frame(width: geometry.size.width * ProductListConstants.paymentPayButtonWidthRatio)
            
            Rectangle()
                .fill(ProductListConstants.paymentCustomerTypeButtonBackground)
                .frame(width: geometry.size.width * ProductListConstants.paymentCustomerTypeButtonWidthRatio)
        }
        .clipShape(RoundedRectangle(cornerRadius: ProductListConstants.paymentCornerRadius))
    }
    
    func createButtonOverlays(geometry: GeometryProxy) -> some View {
        HStack(spacing: 0) {
            createPayButton(geometry: geometry)
            createCustomerTypeButton(geometry: geometry)
        }
    }
    
    func createPayButton(geometry: GeometryProxy) -> some View {
        Button(action: onPayButtonTapped) {
            Text("PAY \(String(format: "%.2f", totalAmount)) USD")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(ProductListConstants.paymentTextColor)
                .frame(
                    width: geometry.size.width * ProductListConstants.paymentPayButtonWidthRatio,
                    height: ProductListConstants.paymentButtonHeight
                )
                .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .background(Color.clear)
    }
    
    func createCustomerTypeButton(geometry: GeometryProxy) -> some View {
        Button(action: showCustomerTypeActionSheet) {
            Text(selectedCustomerType.name)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(ProductListConstants.paymentTextColor)
                .frame(
                    width: geometry.size.width * ProductListConstants.paymentCustomerTypeButtonWidthRatio,
                    height: ProductListConstants.paymentButtonHeight
                )
                .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .background(Color.clear)
    }
    
    var currencyConversionSection: some View {
        HStack {
            Text("26.01 € | 22.38 £")
                .font(.subheadline)
        }
    }
    
    var customerTypeActionSheet: ActionSheet {
        ActionSheet(
            title: Text(ProductListConstants.paymentActionSheetTitle),
            buttons: actionSheetButtons
        )
    }
    
    var actionSheetButtons: [ActionSheet.Button] {
        let customerTypeButtons = customerTypes.map { customerType in
            ActionSheet.Button.default(Text(customerType.name)) {
                onCustomerTypeChange(customerType)
            }
        }
        
        return customerTypeButtons + [.cancel(Text(ProductListConstants.paymentActionSheetCancel))]
    }
}

// MARK: - Private Methods

private extension PaymentSectionView {
    
    func showCustomerTypeActionSheet() {
        isShowingCustomerTypeActionSheet = true
    }
}

