//
//  UseCaseFactoryTests.swift
//  FlyShopUnitTests
//
//  Created by Olga Covaliova on 18.10.2025.
//

import Testing
import Foundation
@testable import fly_shop

struct UseCaseFactoryTests {
    
    // MARK: - Use Case Creation Tests
    
    @Test("Should create customer types use case")
    func testMakeGetCustomerTypesUseCase() {
        // Given
        let mockRepositories = createMockRepositories()
        let mockRepositoryFactory = createMockRepositoryFactory()
        let factory = UseCaseFactory(repositories: mockRepositories, repositoryFactory: mockRepositoryFactory)
        
        // When
        let useCases = factory.makeProductListUseCases()
        
        // Then
        #expect(useCases.getCustomerTypes is GetCustomerTypesUseCase)
    }
    
    @Test("Should create categories use case")
    func testMakeGetCategoriesUseCase() {
        // Given
        let mockRepositories = createMockRepositories()
        let mockRepositoryFactory = createMockRepositoryFactory()
        let factory = UseCaseFactory(repositories: mockRepositories, repositoryFactory: mockRepositoryFactory)
        
        // When
        let useCases = factory.makeProductListUseCases()
        
        // Then
        #expect(useCases.getCategories is GetCategoriesUseCase)
    }
    
    @Test("Should create product list use case")
    func testMakeGetProductListUseCase() {
        // Given
        let mockRepositories = createMockRepositories()
        let mockRepositoryFactory = createMockRepositoryFactory()
        let factory = UseCaseFactory(repositories: mockRepositories, repositoryFactory: mockRepositoryFactory)
        
        // When
        let useCases = factory.makeProductListUseCases()
        
        // Then
        #expect(useCases.getProductList is GetProductListUseCase)
    }
    
    @Test("Should create product list use cases container")
    func testMakeProductListUseCases() {
        // Given
        let mockRepositories = createMockRepositories()
        let mockRepositoryFactory = createMockRepositoryFactory()
        let factory = UseCaseFactory(repositories: mockRepositories, repositoryFactory: mockRepositoryFactory)
        
        // When
        let useCases = factory.makeProductListUseCases()
        
        // Then
        #expect(useCases.getCustomerTypes is GetCustomerTypesUseCase)
        #expect(useCases.getCategories is GetCategoriesUseCase)
        #expect(useCases.getProductList is GetProductListUseCase)
    }
    
    // MARK: - Consistency Tests
    
    @Test("Should create consistent use cases across multiple calls")
    func testConsistentUseCaseCreation() {
        // Given
        let mockRepositories = createMockRepositories()
        let mockRepositoryFactory = createMockRepositoryFactory()
        let factory = UseCaseFactory(repositories: mockRepositories, repositoryFactory: mockRepositoryFactory)
        
        // When
        let firstCall = factory.makeProductListUseCases()
        let secondCall = factory.makeProductListUseCases()
        
        // Then
        #expect(firstCall.getCustomerTypes is GetCustomerTypesUseCase)
        #expect(secondCall.getCustomerTypes is GetCustomerTypesUseCase)
        #expect(firstCall.getCategories is GetCategoriesUseCase)
        #expect(secondCall.getCategories is GetCategoriesUseCase)
        #expect(firstCall.getProductList is GetProductListUseCase)
        #expect(secondCall.getProductList is GetProductListUseCase)
    }
    
    // MARK: - Edge Cases
    
    @Test("Should handle multiple factory instances")
    func testMultipleFactoryInstances() {
        // Given
        let mockRepositories1 = createMockRepositories()
        let mockRepositories2 = createMockRepositories()
        let mockRepositoryFactory1 = createMockRepositoryFactory()
        let mockRepositoryFactory2 = createMockRepositoryFactory()
        let factory1 = UseCaseFactory(repositories: mockRepositories1, repositoryFactory: mockRepositoryFactory1)
        let factory2 = UseCaseFactory(repositories: mockRepositories2, repositoryFactory: mockRepositoryFactory2)
        
        // When
        let useCases1 = factory1.makeProductListUseCases()
        let useCases2 = factory2.makeProductListUseCases()
        
        // Then
        #expect(useCases1.getCustomerTypes is GetCustomerTypesUseCase)
        #expect(useCases2.getCustomerTypes is GetCustomerTypesUseCase)
        #expect(useCases1.getCategories is GetCategoriesUseCase)
        #expect(useCases2.getCategories is GetCategoriesUseCase)
        #expect(useCases1.getProductList is GetProductListUseCase)
        #expect(useCases2.getProductList is GetProductListUseCase)
    }
    
    @Test("Should create process payment use case")
    func testMakeProcessPaymentUseCase() {
        // Given
        let mockRepositories = createMockRepositories()
        let mockRepositoryFactory = createMockRepositoryFactory()
        let factory = UseCaseFactory(repositories: mockRepositories, repositoryFactory: mockRepositoryFactory)
        
        // When
        let useCase = factory.makeProcessPaymentUseCase()
        
        // Then
        #expect(useCase is ProcessPaymentUseCase)
    }
    
    // MARK: - Helper Methods
    
    private func createMockRepositories() -> ProductListRepositories {
        return ProductListRepositories(
            customerType: MockCustomerTypeRepository(),
            category: MockCategoryRepository(),
            product: MockProductListRepository()
        )
    }
    
    private func createMockRepositoryFactory() -> MockRepositoryFactory {
        return MockRepositoryFactory()
    }
}
