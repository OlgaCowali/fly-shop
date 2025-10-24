//
//  DataSourceFactoryTests.swift
//  FlyShopUnitTests
//
//  Created by Olga Covaliova on 18.10.2025.
//

import Testing
import Foundation
@testable import fly_shop

struct DataSourceFactoryTests {
    
    // MARK: - Data Source Creation Tests
    
    @Test("Should create customer type data source")
    func testMakeCustomerTypeDataSource() {
        // Given
        let mockHTTPClient = MockHTTPClient()
        let factory = DataSourceFactory(httpClient: mockHTTPClient)
        
        // When
        let dataSource = factory.makeCustomerTypeDataSource()
        
        // Then
        #expect(dataSource is APICustomerTypeDataSourceImpl)
    }
    
    @Test("Should create category data source")
    func testMakeCategoryDataSource() {
        // Given
        let mockHTTPClient = MockHTTPClient()
        let factory = DataSourceFactory(httpClient: mockHTTPClient)
        
        // When
        let dataSource = factory.makeCategoryDataSource()
        
        // Then
        #expect(dataSource is APICategoriesDataSourceImpl)
    }
    
    @Test("Should create product data source")
    func testMakeProductDataSource() {
        // Given
        let mockHTTPClient = MockHTTPClient()
        let factory = DataSourceFactory(httpClient: mockHTTPClient)
        
        // When
        let dataSource = factory.makeProductDataSource()
        
        // Then
        #expect(dataSource is APIProductListDataSourceImpl)
    }
    
    @Test("Should create product list data sources container")
    func testMakeProductListDataSources() {
        // Given
        let mockHTTPClient = MockHTTPClient()
        let factory = DataSourceFactory(httpClient: mockHTTPClient)
        
        // When
        let dataSources = factory.makeProductListDataSources()
        
        // Then
        #expect(dataSources.customerType is APICustomerTypeDataSourceImpl)
        #expect(dataSources.category is APICategoriesDataSourceImpl)
        #expect(dataSources.product is APIProductListDataSourceImpl)
    }
    
    // MARK: - Consistency Tests
    
    @Test("Should create consistent data sources across multiple calls")
    func testConsistentDataSourceCreation() {
        // Given
        let mockHTTPClient = MockHTTPClient()
        let factory = DataSourceFactory(httpClient: mockHTTPClient)
        
        // When
        let firstCall = factory.makeProductListDataSources()
        let secondCall = factory.makeProductListDataSources()
        
        // Then
        #expect(firstCall.customerType is APICustomerTypeDataSourceImpl)
        #expect(secondCall.customerType is APICustomerTypeDataSourceImpl)
        #expect(firstCall.category is APICategoriesDataSourceImpl)
        #expect(secondCall.category is APICategoriesDataSourceImpl)
        #expect(firstCall.product is APIProductListDataSourceImpl)
        #expect(secondCall.product is APIProductListDataSourceImpl)
    }
    
    @Test("Should use same HTTP client for all data sources")
    func testUsesSameHTTPClient() {
        // Given
        let mockHTTPClient = MockHTTPClient()
        let factory = DataSourceFactory(httpClient: mockHTTPClient)
        
        // When
        let dataSources = factory.makeProductListDataSources()
        
        // Then
        // All data sources should be created with the same HTTP client
        #expect(dataSources.customerType is APICustomerTypeDataSourceImpl)
        #expect(dataSources.category is APICategoriesDataSourceImpl)
        #expect(dataSources.product is APIProductListDataSourceImpl)
    }
    
    // MARK: - Edge Cases
    
    @Test("Should handle multiple factory instances")
    func testMultipleFactoryInstances() {
        // Given
        let mockHTTPClient1 = MockHTTPClient()
        let mockHTTPClient2 = MockHTTPClient()
        let factory1 = DataSourceFactory(httpClient: mockHTTPClient1)
        let factory2 = DataSourceFactory(httpClient: mockHTTPClient2)
        
        // When
        let dataSources1 = factory1.makeProductListDataSources()
        let dataSources2 = factory2.makeProductListDataSources()
        
        // Then
        #expect(dataSources1.customerType is APICustomerTypeDataSourceImpl)
        #expect(dataSources2.customerType is APICustomerTypeDataSourceImpl)
        #expect(dataSources1.category is APICategoriesDataSourceImpl)
        #expect(dataSources2.category is APICategoriesDataSourceImpl)
        #expect(dataSources1.product is APIProductListDataSourceImpl)
        #expect(dataSources2.product is APIProductListDataSourceImpl)
    }
}
