//
//  FlyShopApp.swift
//  fly-shop
//
//  Created by Olga Covaliova on 13.10.2025.
//

import SwiftUI

@main
struct FlyShopApp: App {
    
    @StateObject private var compositionRoot = CompositionRoot()

    var body: some Scene {
        WindowGroup {
            ProductListView(
                viewModel: compositionRoot.makeProductListViewModel(),
                makeCartViewModel: { currency in
                    compositionRoot.makeCartViewViewModel(
                        selectedCurrency: currency
                    )
                }
            )
        }
    }
}
