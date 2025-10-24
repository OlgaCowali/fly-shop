//
//  CartProductListView.swift
//  fly-shop
//
//  Created by Olga Covaliova on 20.10.2025.
//

import SwiftUI

// A view that displays a scrollable list of products in the cart
struct CartProductListView: View {
    let selectedProducts: [Product]
    let viewModel: CartViewViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            // Add top padding
            Spacer()
                .frame(height: CartConstants.topPadding)
            
            List {
                ForEach(selectedProducts) { product in
                    // Display individual product row with cart controls
                    CartProductRow(
                        product: product,
                        viewModel: viewModel
                    )
                    .listRowInsets(EdgeInsets(
                        top: CartConstants.listRowTopInset,
                        leading: CartConstants.horizontalPadding,
                        bottom: CartConstants.productListSpacing,
                        trailing: CartConstants.horizontalPadding
                    ))
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            viewModel.removeProduct(productId: product.id)
                        } label: {
                            Label(CartConstants.deleteActionText, systemImage: CartConstants.deleteActionIcon)
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
        .background(CartConstants.mainViewBackgroundColor)
    }
}
