//
//  ProductListView.swift
//  fly-shop
//
//  Created by Olga Covaliova on 17.10.2025.
//

import SwiftUI
// Uses constants defined in ProductListConstants

struct ProductListView: View {
    @StateObject private var viewModel: ProductListViewModel
    private let columns: [GridItem] = ProductListConstants.gridColumns
    
    init(viewModel: ProductListViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Products Title
                Text(ProductListConstants.titleText)
                    .font(ProductListConstants.titleFont)
                    .fontWeight(ProductListConstants.titleFontWeight)
                    .padding(.top, ProductListConstants.titleTopPadding)
                
                // Category Filter
                HStack {
                    CategoryFilterView(
                        selectedCategory: viewModel.selectedCategory,
                        categories: viewModel.categories,
                        onSelect: { category in
                            viewModel.selectCategory(category)
                        }
                    )
                    Spacer()
                }
                .padding(.horizontal, ProductListConstants.contentPadding)
                
                // Product List
                switch viewModel.state {
                case .loading:
                    ProgressView(ProductListConstants.loadingText)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .loaded:
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: ProductListConstants.gridSpacing) {
                            ForEach(viewModel.products.indices, id: \.self) { index in
                                ProductCardView(
                                    product: viewModel.products[index],
                                    quantity: $viewModel.products[index].quantity
                                )
                            }
                        }
                        .padding(ProductListConstants.contentPadding)
                    }
                case .error:
                    Text("error")
                    // TODO: Error Message
                }
                
                Spacer()
                
                // Payment Section
                PaymentSectionView(
                    totalAmount: 25,
                    selectedCustomerType: viewModel.selectedCustomerType ?? CustomerType(key: "retail", name: "Retail", isDefault: true),
                    customerTypes: viewModel.customerTypes,
                    onCustomerTypeChange: { customerType in
                        viewModel.selectCustomerType(customerType)
                    },
                    onPayButtonTapped: {
                        print("pay")
                        // TODO: Handle payment
                    }
                )
            }
            .task {
                await viewModel.loadInitialData()
            }
        }
    }
}




                                
                          
