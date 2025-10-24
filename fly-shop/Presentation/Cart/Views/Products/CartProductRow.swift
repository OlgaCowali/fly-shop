//
//  CartProductRow.swift
//  fly-shop
//
//  Created by Olga Covaliova on 23.10.2025.
//

import SwiftUI

struct CartProductRow: View {
    let product: Product
    let viewModel: CartViewViewModel
    
    var body: some View {
        HStack(spacing: 0) {
            // Product image on the left
            productImageView
                .padding(.leading, CartConstants.productRowSidePadding)
                .padding(.trailing, CartConstants.productRowSidePadding)
            
            // Product name and price in the middle
            productInfoView
            
            Spacer()
            
            // Product quantity on the right
            quantityView
                .padding(.trailing, CartConstants.productRowSidePadding)
        }
        .padding(CartConstants.productRowPadding)
        .background(Color.white)
        .cornerRadius(CartConstants.cornerRadius)
        .shadow(color: Color.black.opacity(CartConstants.shadowOpacity), radius: CartConstants.shadowRadius, x: 0, y: CartConstants.shadowOffsetY)
    }
    
    // MARK: - Subviews
    
    // Displays the product image with loading states and error handling
    private var productImageView: some View {
        AsyncImage(url: URL(string: product.imageURL)) { phase in
            switch phase {
            case .empty:
                // Show loading indicator while image is being fetched
                createPlaceholderCircle(overlay: ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .secondary)))
            case .success(let image):
                // Display the loaded image as a circular thumbnail
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: CartConstants.productImageSize, height: CartConstants.productImageSize)
                    .clipShape(Circle())
            case .failure:
                // Show placeholder icon when image fails to load
                createPlaceholderCircle(overlay: Image(systemName: CartConstants.placeholderImage)
                    .foregroundColor(.secondary))
            @unknown default:
                // Handle any future AsyncImagePhase cases that might be added
                createPlaceholderCircle(overlay: nil as EmptyView?)
            }
        }
    }
    
    // Displays product name and total price information
    private var productInfoView: some View {
        VStack(alignment: .leading, spacing: CartConstants.productInfoSpacing) {
            // Product name
            Text(product.name)
                .font(CartConstants.productNameFont)
                .foregroundColor(.primary)
            
            // Display total payment for this product using ViewModel method
            if let formattedTotalProductPrice = viewModel.formatTotalPayment(for: product) {
                Text(formattedTotalProductPrice)
                    .font(CartConstants.productPriceFont)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    // Displays the quantity of this product in the cart
    private var quantityView: some View {
        Text("\(product.quantity)")
            .font(CartConstants.quantityFont)
            .foregroundColor(.primary)
    }
    
    // MARK: - Helper Functions
    
    // Creates a circular placeholder background for product images
    @ViewBuilder
    private func createPlaceholderCircle<Overlay: View>(overlay: Overlay?) -> some View {
        Circle()
            .fill(Color.gray.opacity(CartConstants.imageBackgroundOpacity))
            .frame(width: CartConstants.productImageSize, height: CartConstants.productImageSize)
            .overlay(overlay)
    }
}
