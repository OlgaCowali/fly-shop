//
//  CategoryRepositoryImplTests.swift
//  FlyShopUnitTests
//
//  Created by Olga Covaliova on 15.10.2025.
//

import Testing
import Foundation
@testable import fly_shop

struct CategoryRepositoryImplTests {
    
    // MARK: - Test Data
    
    private let sampleCategoryDTOs = [
        CategoryDTO(key: "flies", name: "Flies"),
        CategoryDTO(key: "rods", name: "Rods"),
        CategoryDTO(key: "reels", name: "Reels"),
        CategoryDTO(key: "lines", name: "Lines")
    ]
    
    private let expectedCategories = [
        Category(name: "Flies", key: "flies"),
        Category(name: "Rods", key: "rods"),
        Category(name: "Reels", key: "reels"),
        Category(name: "Lines", key: "lines")
    ]
    
    // MARK: - Success Tests
    
    @Test("Should return mapped categories when data source returns success")
    func testGetCategoriesReturnsMappedCategoriesOnSuccess() async throws {
        // Given
        let mockDataSource = MockAPICategoriesDataSource()
        mockDataSource.getCategoriesResult = .success(sampleCategoryDTOs)
        let repository = CategoryRepositoryImpl(apiDataSource: mockDataSource)
        
        // When
        let result = await repository.getCategories()
        
        // Then
        #expect(mockDataSource.getCategoriesCallCount == 1)
        
        switch result {
        case .success(let categories):
            #expect(categories.count == 4)
            #expect(categories[0].name == "Flies")
            #expect(categories[0].key == "flies")
            #expect(categories[1].name == "Rods")
            #expect(categories[1].key == "rods")
            #expect(categories[2].name == "Reels")
            #expect(categories[2].key == "reels")
            #expect(categories[3].name == "Lines")
            #expect(categories[3].key == "lines")
        case .failure:
            Issue.record("Expected success but got failure")
        }
    }
    
    @Test("Should return empty categories when data source returns empty array")
    func testGetCategoriesReturnsEmptyCategories() async throws {
        // Given
        let mockDataSource = MockAPICategoriesDataSource()
        mockDataSource.getCategoriesResult = .success([])
        let repository = CategoryRepositoryImpl(apiDataSource: mockDataSource)
        
        // When
        let result = await repository.getCategories()
        
        // Then
        #expect(mockDataSource.getCategoriesCallCount == 1)
        
        switch result {
        case .success(let categories):
            #expect(categories.isEmpty)
        case .failure:
            Issue.record("Expected success but got failure")
        }
    }
    
    @Test("Should maintain category order from data source")
    func testMaintainsCategoryOrder() async throws {
        // Given
        let orderedDTOs = [
            CategoryDTO(key: "first", name: "First"),
            CategoryDTO(key: "second", name: "Second"),
            CategoryDTO(key: "third", name: "Third")
        ]
        let mockDataSource = MockAPICategoriesDataSource()
        mockDataSource.getCategoriesResult = .success(orderedDTOs)
        let repository = CategoryRepositoryImpl(apiDataSource: mockDataSource)
        
        // When
        let result = await repository.getCategories()
        
        // Then
        switch result {
        case .success(let categories):
            #expect(categories.count == 3)
            #expect(categories[0].name == "First")
            #expect(categories[0].key == "first")
            #expect(categories[1].name == "Second")
            #expect(categories[1].key == "second")
            #expect(categories[2].name == "Third")
            #expect(categories[2].key == "third")
        case .failure:
            Issue.record("Expected success but got failure")
        }
    }
    
    // MARK: - Error Tests
    
    @Test("Should map clientError to network error")
    func testMapsClientErrorToNetworkError() async throws {
        // Given
        let mockDataSource = MockAPICategoriesDataSource()
        mockDataSource.getCategoriesResult = .failure(.clientError)
        let repository = CategoryRepositoryImpl(apiDataSource: mockDataSource)
        
        // When
        let result = await repository.getCategories()
        
        // Then
        #expect(mockDataSource.getCategoriesCallCount == 1)
        
        switch result {
        case .success:
            Issue.record("Expected failure but got success")
        case .failure(let error):
            #expect(error == .network)
        }
    }
    
    @Test("Should map serverError to server error")
    func testMapsServerErrorToServerError() async throws {
        // Given
        let mockDataSource = MockAPICategoriesDataSource()
        mockDataSource.getCategoriesResult = .failure(.serverError)
        let repository = CategoryRepositoryImpl(apiDataSource: mockDataSource)
        
        // When
        let result = await repository.getCategories()
        
        // Then
        #expect(mockDataSource.getCategoriesCallCount == 1)
        
        switch result {
        case .success:
            Issue.record("Expected failure but got success")
        case .failure(let error):
            #expect(error == .server)
        }
    }
    
    @Test("Should map parsingError to decoding error")
    func testMapsParsingErrorToDecodingError() async throws {
        // Given
        let mockDataSource = MockAPICategoriesDataSource()
        mockDataSource.getCategoriesResult = .failure(.parsingError)
        let repository = CategoryRepositoryImpl(apiDataSource: mockDataSource)
        
        // When
        let result = await repository.getCategories()
        
        // Then
        #expect(mockDataSource.getCategoriesCallCount == 1)
        
        switch result {
        case .success:
            Issue.record("Expected failure but got success")
        case .failure(let error):
            #expect(error == .decoding)
        }
    }
    
    @Test("Should map responseError to network error")
    func testMapsResponseErrorToNetworkError() async throws {
        // Given
        let mockDataSource = MockAPICategoriesDataSource()
        mockDataSource.getCategoriesResult = .failure(.responseError)
        let repository = CategoryRepositoryImpl(apiDataSource: mockDataSource)
        
        // When
        let result = await repository.getCategories()
        
        // Then
        #expect(mockDataSource.getCategoriesCallCount == 1)
        
        switch result {
        case .success:
            Issue.record("Expected failure but got success")
        case .failure(let error):
            #expect(error == .network)
        }
    }
    
    @Test("Should map generic error to generic error")
    func testMapsGenericErrorToGenericError() async throws {
        // Given
        let mockDataSource = MockAPICategoriesDataSource()
        mockDataSource.getCategoriesResult = .failure(.generic)
        let repository = CategoryRepositoryImpl(apiDataSource: mockDataSource)
        
        // When
        let result = await repository.getCategories()
        
        // Then
        #expect(mockDataSource.getCategoriesCallCount == 1)
        
        switch result {
        case .success:
            Issue.record("Expected failure but got success")
        case .failure(let error):
            #expect(error == .generic)
        }
    }
    
    // MARK: - Edge Cases
    
    @Test("Should handle very long category names and keys")
    func testHandlesLongCategoryNamesAndKeys() async throws {
        // Given
        let longName = String(repeating: "Very Long Category Name ", count: 10)
        let longKey = String(repeating: "very-long-key-", count: 20)
        let longDTOs = [CategoryDTO(key: longKey, name: longName)]
        let mockDataSource = MockAPICategoriesDataSource()
        mockDataSource.getCategoriesResult = .success(longDTOs)
        let repository = CategoryRepositoryImpl(apiDataSource: mockDataSource)
        
        // When
        let result = await repository.getCategories()
        
        // Then
        switch result {
        case .success(let categories):
            #expect(categories.count == 1)
            #expect(categories[0].name == longName)
            #expect(categories[0].key == longKey)
        case .failure:
            Issue.record("Expected success but got failure")
        }
    }
}
