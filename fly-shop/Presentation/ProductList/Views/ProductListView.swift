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
    @State private var showingCart = false
    // Grid layout configuration for the product cards
    private let columns: [GridItem] = ProductListConstants.gridColumns
    
    // Factory closure for creating cart view model
    private let makeCartViewModel: (Currency) -> CartViewViewModel
    
    init(
        viewModel: ProductListViewModel,
        makeCartViewModel: @escaping (Currency) -> CartViewViewModel
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.makeCartViewModel = makeCartViewModel
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
                
                // Product List - displays different states based on data loading
                switch viewModel.state {
                case .loading:
                    LoadingStateView(
                        loadingText: ProductListConstants.loadingText,
                        spacing: CommonConstants.loadingStateSpacing,
                        padding: CommonConstants.loadingStatePadding,
                        indicatorColor: CommonConstants.loadingIndicatorColor,
                        indicatorScale: CommonConstants.loadingIndicatorScale,
                        textFont: CommonConstants.loadingTextFont,
                        textColor: CommonConstants.loadingTextColor
                    )
                case .loaded:
                    // Display products in a grid layout
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: ProductListConstants.gridSpacing) {
                            ForEach(viewModel.displayedProducts) { product in
                                ProductCardView(
                                    product: product,
                                    selectedCurrency: viewModel.selectedCurrency,
                                    onQuantityChange: { productId, quantity in
                                        viewModel.updateProductQuantity(productId, quantity: quantity)
                                    }
                                )
                            }
                        }
                        .padding(ProductListConstants.contentPadding)
                    }
                case .error(let error):
                    // Show common error state
                    ErrorStateView(
                        error: error,
                        onRetry: {
                            Task {
                                await viewModel.loadInitialData()
                            }
                        }
                    )
                case .empty:
                    EmptyStateView(
                        message: ProductListConstants.emptyListMessage,
                        font: CommonConstants.emptyScreenFont
                    )
                }
                
                Spacer()
                
                // Payment section - only shown when data is loaded and customer type is selected
                if case .loaded = viewModel.state,
                   let customerType = viewModel.selectedCustomerType {
                    PaymentSectionView(
                        totalAmount: viewModel.totalAmount,
                        selectedCurrency: viewModel.selectedCurrency,
                        totalsByCurrency: viewModel.totalsByCurrency,
                        selectedCustomerType: customerType,
                        customerTypes: viewModel.customerTypes,
                        onCustomerTypeChange: { customerType in
                            viewModel.selectCustomerType(customerType)
                        },
                        onPayButtonTapped: {
                            showingCart = true
                        },
                        onCurrencyChange: { currency in
                            viewModel.selectCurrency(currency)
                        }
                    )
                }
            }
            .task {
                // Load initial data when the view appears
                await viewModel.loadInitialData()
            }
            .fullScreenCover(isPresented: $showingCart) {
                CartView(
                    viewModel: makeCartViewModel(
                        viewModel.selectedCurrency
                    )
                )
            }
        }
    }
}
