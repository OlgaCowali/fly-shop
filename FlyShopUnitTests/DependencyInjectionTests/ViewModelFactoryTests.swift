//
//  ViewModelFactoryTests.swift
//  FlyShopUnitTests
//
//  Created by Olga Covaliova on 18.10.2025.
//

import Testing
import Foundation
@testable import fly_shop

struct ViewModelFactoryTests {
    
    // MARK: - ViewModel Creation Tests
    
    @MainActor @Test("Should create product list view model with correct initial state")
    func testMakeProductListViewModel() {
        // Given
        let mockUseCases = createMockUseCases()
        let factory = ViewModelFactory(useCases: mockUseCases)
        
        // When
        let viewModel = factory.makeProductListViewModel()
        
        // Then
        #expect(viewModel.state == .loading)
        #expect(viewModel.displayedProducts.isEmpty)
        #expect(viewModel.categories.isEmpty)
        #expect(viewModel.customerTypes.isEmpty)
        #expect(viewModel.selectedCurrency == .usd)
    }
    
    @MainActor @Test("Should create consistent view model across multiple calls")
    func testConsistentViewModelCreation() {
        // Given
        let mockUseCases = createMockUseCases()
        let factory = ViewModelFactory(useCases: mockUseCases)
        
        // When
        let firstViewModel = factory.makeProductListViewModel()
        let secondViewModel = factory.makeProductListViewModel()
        
        // Then
        #expect(firstViewModel.state == secondViewModel.state)
        #expect(firstViewModel.selectedCurrency == secondViewModel.selectedCurrency)
        #expect(firstViewModel.displayedProducts.count == secondViewModel.displayedProducts.count)
    }
    
    @MainActor @Test("Should handle multiple factory instances")
    func testMultipleFactoryInstances() {
        // Given
        let mockUseCases1 = createMockUseCases()
        let mockUseCases2 = createMockUseCases()
        let factory1 = ViewModelFactory(useCases: mockUseCases1)
        let factory2 = ViewModelFactory(useCases: mockUseCases2)
        
        // When
        let viewModel1 = factory1.makeProductListViewModel()
        let viewModel2 = factory2.makeProductListViewModel()
        
        // Then
        #expect(viewModel1.state == .loading)
        #expect(viewModel2.state == .loading)
        #expect(viewModel1.selectedCurrency == viewModel2.selectedCurrency)
    }
    
    // MARK: - Helper Methods
    
    private func createMockUseCases() -> ProductListUseCases {
        return ProductListUseCases(
            getCustomerTypes: MockGetCustomerTypesUseCase(),
            getCategories: MockGetCategoriesUseCase(),
            getProductList: MockGetProductListUseCase()
        )
    }
}



