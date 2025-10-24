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
        let mockCartServices = createMockCartServices()
        let factory = ViewModelFactory(useCases: mockUseCases, cartServices: mockCartServices)
        
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
        let mockCartServices = createMockCartServices()
        let factory = ViewModelFactory(useCases: mockUseCases, cartServices: mockCartServices)
        
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
        let mockCartServices1 = createMockCartServices()
        let mockCartServices2 = createMockCartServices()
        let factory1 = ViewModelFactory(useCases: mockUseCases1, cartServices: mockCartServices1)
        let factory2 = ViewModelFactory(useCases: mockUseCases2, cartServices: mockCartServices2)
        
        // When
        let viewModel1 = factory1.makeProductListViewModel()
        let viewModel2 = factory2.makeProductListViewModel()
        
        // Then
        #expect(viewModel1.state == .loading)
        #expect(viewModel2.state == .loading)
        #expect(viewModel1.selectedCurrency == viewModel2.selectedCurrency)
    }
    
    @MainActor @Test("Should create cart view model with correct initial state")
    func testMakeCartViewViewModel() {
        // Given
        let mockUseCases = createMockUseCases()
        let mockCartServices = createMockCartServices()
        let factory = ViewModelFactory(useCases: mockUseCases, cartServices: mockCartServices)
        
        // When
        let viewModel = factory.makeCartViewViewModel(selectedCurrency: .usd)
        
        // Then
        #expect(viewModel.selectedCurrency == .usd)
        #expect(viewModel.selectedSeat == "A 1")
        #expect(viewModel.isDismissed == false)
    }
    
    @MainActor @Test("Should create cart view model with seat from session service")
    func testMakeCartViewViewModelWithCustomSeat() {
        // Given
        let mockUseCases = createMockUseCases()
        let mockCartServices = createMockCartServices()
        mockCartServices.sessionService.selectedSeat = "B 3"
        let factory = ViewModelFactory(useCases: mockUseCases, cartServices: mockCartServices)
        
        // When
        let viewModel = factory.makeCartViewViewModel(selectedCurrency: .eur)
        
        // Then
        #expect(viewModel.selectedSeat == "B 3")
        #expect(viewModel.selectedCurrency == .eur)
    }
    
    // MARK: - Helper Methods
    
    private func createMockUseCases() -> ProductListUseCases {
        return ProductListUseCases(
            getCustomerTypes: MockGetCustomerTypesUseCase(),
            getCategories: MockGetCategoriesUseCase(),
            getProductList: MockGetProductListUseCase()
        )
    }
    
    @MainActor
    private func createMockCartServices() -> CartServices {
        return CartServices(
            sessionService: MockCartSessionService(),
            cashPaymentService: MockCashPaymentService(),
            cardPaymentService: MockCardPaymentService()
        )
    }
    
    private func createTestProducts() -> [Product] {
        let category = Category(name: "Test", key: "test")
        let customerType = CustomerType(key: "standard", name: "Standard")
        
        return [
            Product(
                id: UUID(),
                name: "Product 1",
                prices: [.usd: 10.00, .eur: 9.00, .gbp: 8.00],
                imageURL: "test1.jpg",
                category: category,
                quantity: 1,
                customerType: customerType
            )
        ]
    }
}



