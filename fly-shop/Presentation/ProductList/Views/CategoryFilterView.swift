//
//  CategoryFilterView.swift
//  fly-shop
//
//  Created by Olga Covaliova on 20.10.2025.
//

import SwiftUI

struct CategoryFilterView: View {
    let selectedCategory: Category?
    let categories: [Category]
    let onSelect: (Category?) -> Void
    
    @State private var isPresented = false
    
    var body: some View {
        // Filter button with dropdown indicator
        Button(action: { isPresented = true }) {
            HStack(spacing: 8) {
                // Display current filter selection or "All Products"
                Text("\(ProductListConstants.filterPrefixText) \(selectedCategory?.name ?? ProductListConstants.allProductsText)")
                    .foregroundColor(ProductListConstants.filterTextColor)
                    .font(ProductListConstants.filterTextFont)
                
                // Dropdown arrow icon
                Image(systemName: ProductListConstants.filterDropdownIcon)
                    .foregroundColor(ProductListConstants.filterIconColor)
                    .font(ProductListConstants.filterIconFont)
            }
            .padding(.horizontal, ProductListConstants.filterHorizontalPadding)
            .padding(.vertical, ProductListConstants.filterVerticalPadding)
            .background(ProductListConstants.filterBackgroundColor)
            .cornerRadius(ProductListConstants.filterCornerRadius)
        }
        .buttonStyle(PlainButtonStyle())
        
        // Action sheet for category selection
        .actionSheet(isPresented: $isPresented) {
            ActionSheet(
                title: Text(ProductListConstants.selectCategoryTitle),
                buttons: createButtons()
            )
        }
    }
    
    // MARK: - Private Methods
    
    // Creates action sheet buttons for category selection
    private func createButtons() -> [ActionSheet.Button] {
        var result: [ActionSheet.Button] = []
        
        // Add "All Products" option
        result.append(.default(Text(ProductListConstants.allProductsText)) { onSelect(nil) })
        
        // Add individual category options
        for category in categories {
            result.append(.default(Text(category.name)) { onSelect(category) })
        }
        
        // Add cancel button
        result.append(.cancel())
        return result
    }
}


