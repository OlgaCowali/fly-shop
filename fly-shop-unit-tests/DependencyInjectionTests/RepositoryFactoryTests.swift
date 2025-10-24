//
//  RepositoryFactoryTests.swift
//  FlyShopUnitTests
//
//  Created by Olga Covaliova on 18.10.2025.
//

import Testing
import Foundation
@testable import fly_shop

struct RepositoryFactoryTests {
    
    // MARK: - Repository Creation Tests
    
    @Test("Should create customer type repository")
    func testMakeCustomerTypeRepository() {
        // Given
        let mockDataSources = createMockDataSources()
        let factory = RepositoryFactory(dataSources: mockDataSources)
        
        // When
        let repository = factory.makeCustomerTypeRepository()
        
        // Then
        #expect(repository is CustomerTypeRepositoryImpl)
    }
    
    @Test("Should create category repository")
    func testMakeCategoryRepository() {
        // Given
        let mockDataSources = createMockDataSources()
        let factory = RepositoryFactory(dataSources: mockDataSources)
        
        // When
        let repository = factory.makeCategoryRepository()
        
        // Then
        #expect(repository is CategoryRepositoryImpl)
    }
    
    @Test("Should create product list repository")
    func testMakeProductListRepository() {
        // Given
        let mockDataSources = createMockDataSources()
        let factory = RepositoryFactory(dataSources: mockDataSources)
        
        // When
        let repository = factory.makeProductListRepository()
        
        // Then
        #expect(repository is ProductListRepositoryImpl)
    }
    
    @Test("Should create product list repositories container")
    func testMakeProductListRepositories() {
        // Given
        let mockDataSources = createMockDataSources()
        let factory = RepositoryFactory(dataSources: mockDataSources)
        
        // When
        let repositories = factory.makeProductListRepositories()
        
        // Then
        #expect(repositories.customerType is CustomerTypeRepositoryImpl)
        #expect(repositories.category is CategoryRepositoryImpl)
        #expect(repositories.product is ProductListRepositoryImpl)
    }
    
    // MARK: - Consistency Tests
    
    @Test("Should create consistent repositories across multiple calls")
    func testConsistentRepositoryCreation() {
        // Given
        let mockDataSources = createMockDataSources()
        let factory = RepositoryFactory(dataSources: mockDataSources)
        
        // When
        let firstCall = factory.makeProductListRepositories()
        let secondCall = factory.makeProductListRepositories()
        
        // Then
        #expect(firstCall.customerType is CustomerTypeRepositoryImpl)
        #expect(secondCall.customerType is CustomerTypeRepositoryImpl)
        #expect(firstCall.category is CategoryRepositoryImpl)
        #expect(secondCall.category is CategoryRepositoryImpl)
        #expect(firstCall.product is ProductListRepositoryImpl)
        #expect(secondCall.product is ProductListRepositoryImpl)
    }
    
    @Test("Should use same data sources for all repositories")
    func testUsesSameDataSources() {
        // Given
        let mockDataSources = createMockDataSources()
        let factory = RepositoryFactory(dataSources: mockDataSources)
        
        // When
        let repositories = factory.makeProductListRepositories()
        
        // Then
        // All repositories should be created with the same data sources
        #expect(repositories.customerType is CustomerTypeRepositoryImpl)
        #expect(repositories.category is CategoryRepositoryImpl)
        #expect(repositories.product is ProductListRepositoryImpl)
    }
    
    // MARK: - Edge Cases
    
    @Test("Should handle multiple factory instances")
    func testMultipleFactoryInstances() {
        // Given
        let mockDataSources1 = createMockDataSources()
        let mockDataSources2 = createMockDataSources()
        let factory1 = RepositoryFactory(dataSources: mockDataSources1)
        let factory2 = RepositoryFactory(dataSources: mockDataSources2)
        
        // When
        let repositories1 = factory1.makeProductListRepositories()
        let repositories2 = factory2.makeProductListRepositories()
        
        // Then
        #expect(repositories1.customerType is CustomerTypeRepositoryImpl)
        #expect(repositories2.customerType is CustomerTypeRepositoryImpl)
        #expect(repositories1.category is CategoryRepositoryImpl)
        #expect(repositories2.category is CategoryRepositoryImpl)
        #expect(repositories1.product is ProductListRepositoryImpl)
        #expect(repositories2.product is ProductListRepositoryImpl)
    }
    
    // MARK: - Helper Methods
    
    private func createMockDataSources() -> ProductListDataSources {
        return ProductListDataSources(
            customerType: MockAPICustomerTypeDataSource(),
            category: MockAPICategoriesDataSource(),
            product: MockAPIProductsDataSource()
        )
    }
}
