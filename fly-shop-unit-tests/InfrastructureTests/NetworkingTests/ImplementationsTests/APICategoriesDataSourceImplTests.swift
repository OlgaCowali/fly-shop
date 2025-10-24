//
//  APICategoriesDataSourceImplTests.swift
//  FlyShopUnitTests
//
//  Created by Olga Covaliova on 16.10.2025.
//

import Testing
import Foundation
@testable import fly_shop

struct APICategoriesDataSourceImplTests {
    
    // MARK: - Test Data
    
    private let validCategoriesJSON = """
    [
        {
            "key": "flies",
            "name": "Flies"
        },
        {
            "key": "rods",
            "name": "Fishing Rods"
        },
        {
            "key": "reels",
            "name": "Reels"
        }
    ]
    """.data(using: .utf8)!
    
    private let invalidJSON = """
    {
        "invalid": "json structure"
    }
    """.data(using: .utf8)!
    
    private let emptyArrayJSON = "[]".data(using: .utf8)!
    
    // MARK: - Success Tests
    
    @Test("Should return success with categories when API returns valid JSON")
    func testGetCategoriesReturnsSuccessWithValidJSON() async throws {
        // Given
        let mockHTTPClient = MockHTTPClient()
        mockHTTPClient.setSuccessResult(data: validCategoriesJSON)
        let dataSource = APICategoriesDataSourceImpl(httpClient: mockHTTPClient)
        
        // When
        let result = await dataSource.getCategories()
        
        // Then
        switch result {
        case .success(let categories):
            #expect(categories.count == 3)
            #expect(categories[0].key == "flies")
            #expect(categories[0].name == "Flies")
            #expect(categories[1].key == "rods")
            #expect(categories[1].name == "Fishing Rods")
            #expect(categories[2].key == "reels")
            #expect(categories[2].name == "Reels")
        case .failure:
            Issue.record("Expected success but got failure")
        }
        
        // Verify HTTP client was called correctly
        #expect(mockHTTPClient.makeRequestCallCount == 1)
        #expect(mockHTTPClient.lastEndpoint?.method == .get)
        #expect(mockHTTPClient.lastEndpoint?.path == APIConstant.baseURLString + APIConstant.productCategoryURL)
    }
    
    @Test("Should return success with empty array when API returns empty JSON array")
    func testGetCategoriesReturnsSuccessWithEmptyArray() async throws {
        // Given
        let mockHTTPClient = MockHTTPClient()
        mockHTTPClient.setSuccessResult(data: emptyArrayJSON)
        let dataSource = APICategoriesDataSourceImpl(httpClient: mockHTTPClient)
        
        // When
        let result = await dataSource.getCategories()
        
        // Then
        switch result {
        case .success(let categories):
            #expect(categories.isEmpty)
        case .failure:
            Issue.record("Expected success but got failure")
        }
        
        #expect(mockHTTPClient.makeRequestCallCount == 1)
    }
    
    @Test("Should construct correct URL using API constants")
    func testGetCategoriesUsesCorrectURL() async throws {
        // Given
        let mockHTTPClient = MockHTTPClient()
        mockHTTPClient.setSuccessResult(data: validCategoriesJSON)
        let dataSource = APICategoriesDataSourceImpl(httpClient: mockHTTPClient)
        let expectedURL = APIConstant.baseURLString + APIConstant.productCategoryURL
        
        // When
        _ = await dataSource.getCategories()
        
        // Then
        #expect(mockHTTPClient.lastEndpoint?.path == expectedURL)
        #expect(mockHTTPClient.lastEndpoint?.method == .get)
    }
    
    // MARK: - Error Tests
    
    @Test("Should return parsing error when API returns invalid JSON")
    func testGetCategoriesReturnsParsingErrorForInvalidJSON() async throws {
        // Given
        let mockHTTPClient = MockHTTPClient()
        mockHTTPClient.setSuccessResult(data: invalidJSON)
        let dataSource = APICategoriesDataSourceImpl(httpClient: mockHTTPClient)
        
        // When
        let result = await dataSource.getCategories()
        
        // Then
        switch result {
        case .success:
            Issue.record("Expected failure but got success")
        case .failure(let error):
            #expect(error == .parsingError)
        }
        
        #expect(mockHTTPClient.makeRequestCallCount == 1)
    }
    
    @Test("Should return client error when HTTP client returns client error")
    func testGetCategoriesReturnsClientError() async throws {
        // Given
        let mockHTTPClient = MockHTTPClient()
        mockHTTPClient.setFailureResult(error: .clientError)
        let dataSource = APICategoriesDataSourceImpl(httpClient: mockHTTPClient)
        
        // When
        let result = await dataSource.getCategories()
        
        // Then
        switch result {
        case .success:
            Issue.record("Expected failure but got success")
        case .failure(let error):
            #expect(error == .clientError)
        }
        
        #expect(mockHTTPClient.makeRequestCallCount == 1)
    }
    
    @Test("Should return server error when HTTP client returns server error")
    func testGetCategoriesReturnsServerError() async throws {
        // Given
        let mockHTTPClient = MockHTTPClient()
        mockHTTPClient.setFailureResult(error: .serverError)
        let dataSource = APICategoriesDataSourceImpl(httpClient: mockHTTPClient)
        
        // When
        let result = await dataSource.getCategories()
        
        // Then
        switch result {
        case .success:
            Issue.record("Expected failure but got success")
        case .failure(let error):
            #expect(error == .serverError)
        }
        
        #expect(mockHTTPClient.makeRequestCallCount == 1)
    }
    
    @Test("Should return response error when HTTP client returns response error")
    func testGetCategoriesReturnsResponseError() async throws {
        // Given
        let mockHTTPClient = MockHTTPClient()
        mockHTTPClient.setFailureResult(error: .responseError)
        let dataSource = APICategoriesDataSourceImpl(httpClient: mockHTTPClient)
        
        // When
        let result = await dataSource.getCategories()
        
        // Then
        switch result {
        case .success:
            Issue.record("Expected failure but got success")
        case .failure(let error):
            #expect(error == .responseError)
        }
        
        #expect(mockHTTPClient.makeRequestCallCount == 1)
    }
    
    @Test("Should return generic error when HTTP client returns unexpected result")
    func testGetCategoriesReturnsGenericErrorForUnexpectedResult() async throws {
        // Given
        let mockHTTPClient = MockHTTPClient()

        mockHTTPClient.makeRequestResult = .failure(.generic)
        let dataSource = APICategoriesDataSourceImpl(httpClient: mockHTTPClient)
        
        // When
        let result = await dataSource.getCategories()
        
        // Then
        switch result {
        case .success:
            Issue.record("Expected failure but got success")
        case .failure(let error):
            #expect(error == .generic)
        }
        
        #expect(mockHTTPClient.makeRequestCallCount == 1)
    }
    
    @Test("Should handle empty data response")
    func testGetCategoriesHandlesEmptyData() async throws {
        // Given
        let emptyData = Data()
        let mockHTTPClient = MockHTTPClient()
        mockHTTPClient.setSuccessResult(data: emptyData)
        let dataSource = APICategoriesDataSourceImpl(httpClient: mockHTTPClient)
        
        // When
        let result = await dataSource.getCategories()
        
        // Then
        switch result {
        case .success:
            Issue.record("Expected failure but got success")
        case .failure(let error):
            #expect(error == .parsingError)
        }
    }
    
    // MARK: - Performance Tests
    
    @Test("Should make only one HTTP request per call")
    func testGetCategoriesMakesOnlyOneHTTPRequest() async throws {
        // Given
        let mockHTTPClient = MockHTTPClient()
        mockHTTPClient.setSuccessResult(data: validCategoriesJSON)
        let dataSource = APICategoriesDataSourceImpl(httpClient: mockHTTPClient)
        
        // When
        _ = await dataSource.getCategories()
        
        // Then
        #expect(mockHTTPClient.makeRequestCallCount == 1)
    }
    
}
