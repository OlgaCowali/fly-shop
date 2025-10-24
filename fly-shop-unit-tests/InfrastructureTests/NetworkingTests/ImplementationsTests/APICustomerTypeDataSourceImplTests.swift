//
//  APICustomerTypeDataSourceImplTests.swift
//  FlyShopUnitTests
//
//  Created by Olga Covaliova on 16.10.2025.
//

import Testing
import Foundation
@testable import fly_shop

struct APICustomerTypeDataSourceImplTests {
    
    // MARK: - Test Data
    
    private let validCustomerTypesJSON = """
    [
        {
            "key": "individual",
            "name": "Individual",
            "isDefault": true
        },
        {
            "key": "business",
            "name": "Business",
            "isDefault": false
        },
        {
            "key": "wholesale",
            "name": "Wholesale",
            "isDefault": false
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
    
    @Test("Should return success with customer types when API returns valid JSON")
    func testGetCustomerTypesReturnsSuccessWithValidJSON() async throws {
        // Given
        let mockHTTPClient = MockHTTPClient()
        mockHTTPClient.setSuccessResult(data: validCustomerTypesJSON)
        let dataSource = APICustomerTypeDataSourceImpl(httpClient: mockHTTPClient)
        
        // When
        let result = await dataSource.getCustomerTypes()
        
        // Then
        switch result {
        case .success(let customerTypes):
            #expect(customerTypes.count == 3)
            #expect(customerTypes[0].key == "individual")
            #expect(customerTypes[0].name == "Individual")
            #expect(customerTypes[0].isDefault == true)
            #expect(customerTypes[1].key == "business")
            #expect(customerTypes[1].name == "Business")
            #expect(customerTypes[1].isDefault == false)
            #expect(customerTypes[2].key == "wholesale")
            #expect(customerTypes[2].name == "Wholesale")
            #expect(customerTypes[2].isDefault == false)
        case .failure:
            Issue.record("Expected success but got failure")
        }
        
        // Verify HTTP client was called correctly
        #expect(mockHTTPClient.makeRequestCallCount == 1)
        #expect(mockHTTPClient.lastEndpoint?.method == .get)
        #expect(mockHTTPClient.lastEndpoint?.path == APIConstant.baseURLString + APIConstant.customerTypeURL)
    }
    
    @Test("Should return success with empty array when API returns empty JSON array")
    func testGetCustomerTypesReturnsSuccessWithEmptyArray() async throws {
        // Given
        let mockHTTPClient = MockHTTPClient()
        mockHTTPClient.setSuccessResult(data: emptyArrayJSON)
        let dataSource = APICustomerTypeDataSourceImpl(httpClient: mockHTTPClient)
        
        // When
        let result = await dataSource.getCustomerTypes()
        
        // Then
        switch result {
        case .success(let customerTypes):
            #expect(customerTypes.isEmpty)
        case .failure:
            Issue.record("Expected success but got failure")
        }
        
        #expect(mockHTTPClient.makeRequestCallCount == 1)
    }
    
    @Test("Should construct correct URL using API constants")
    func testGetCustomerTypesUsesCorrectURL() async throws {
        // Given
        let mockHTTPClient = MockHTTPClient()
        mockHTTPClient.setSuccessResult(data: validCustomerTypesJSON)
        let dataSource = APICustomerTypeDataSourceImpl(httpClient: mockHTTPClient)
        let expectedURL = APIConstant.baseURLString + APIConstant.customerTypeURL
        
        // When
        _ = await dataSource.getCustomerTypes()
        
        // Then
        #expect(mockHTTPClient.lastEndpoint?.path == expectedURL)
        #expect(mockHTTPClient.lastEndpoint?.method == .get)
    }
    
    // MARK: - Error Tests
    
    @Test("Should return parsing error when API returns invalid JSON")
    func testGetCustomerTypesReturnsParsingErrorForInvalidJSON() async throws {
        // Given
        let mockHTTPClient = MockHTTPClient()
        mockHTTPClient.setSuccessResult(data: invalidJSON)
        let dataSource = APICustomerTypeDataSourceImpl(httpClient: mockHTTPClient)
        
        // When
        let result = await dataSource.getCustomerTypes()
        
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
    func testGetCustomerTypesReturnsClientError() async throws {
        // Given
        let mockHTTPClient = MockHTTPClient()
        mockHTTPClient.setFailureResult(error: .clientError)
        let dataSource = APICustomerTypeDataSourceImpl(httpClient: mockHTTPClient)
        
        // When
        let result = await dataSource.getCustomerTypes()
        
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
    func testGetCustomerTypesReturnsServerError() async throws {
        // Given
        let mockHTTPClient = MockHTTPClient()
        mockHTTPClient.setFailureResult(error: .serverError)
        let dataSource = APICustomerTypeDataSourceImpl(httpClient: mockHTTPClient)
        
        // When
        let result = await dataSource.getCustomerTypes()
        
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
    func testGetCustomerTypesReturnsResponseError() async throws {
        // Given
        let mockHTTPClient = MockHTTPClient()
        mockHTTPClient.setFailureResult(error: .responseError)
        let dataSource = APICustomerTypeDataSourceImpl(httpClient: mockHTTPClient)
        
        // When
        let result = await dataSource.getCustomerTypes()
        
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
    func testGetCustomerTypesReturnsGenericErrorForUnexpectedResult() async throws {
        // Given
        let mockHTTPClient = MockHTTPClient()
        mockHTTPClient.makeRequestResult = .failure(.generic)
        let dataSource = APICustomerTypeDataSourceImpl(httpClient: mockHTTPClient)
        
        // When
        let result = await dataSource.getCustomerTypes()
        
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
    func testGetCustomerTypesHandlesEmptyData() async throws {
        // Given
        let emptyData = Data()
        let mockHTTPClient = MockHTTPClient()
        mockHTTPClient.setSuccessResult(data: emptyData)
        let dataSource = APICustomerTypeDataSourceImpl(httpClient: mockHTTPClient)
        
        // When
        let result = await dataSource.getCustomerTypes()
        
        // Then
        switch result {
        case .success:
            Issue.record("Expected failure but got success")
        case .failure(let error):
            #expect(error == .parsingError)
        }
    }
    
    @Test("Should handle malformed JSON with missing required fields")
    func testGetCustomerTypesHandlesMalformedJSON() async throws {
        // Given
        let malformedJSON = """
        [
            {
                "key": "individual",
                "name": "Individual"
            },
            {
                "key": "business"
            }
        ]
        """.data(using: .utf8)!
        
        let mockHTTPClient = MockHTTPClient()
        mockHTTPClient.setSuccessResult(data: malformedJSON)
        let dataSource = APICustomerTypeDataSourceImpl(httpClient: mockHTTPClient)
        
        // When
        let result = await dataSource.getCustomerTypes()
        
        // Then
        switch result {
        case .success:
            Issue.record("Expected failure but got success")
        case .failure(let error):
            #expect(error == .parsingError)
        }
    }
    
    @Test("Should handle JSON with null values")
    func testGetCustomerTypesHandlesNullValues() async throws {
        // Given
        let nullValuesJSON = """
        [
            {
                "key": "individual",
                "name": "Individual",
                "isDefault": null
            }
        ]
        """.data(using: .utf8)!
        
        let mockHTTPClient = MockHTTPClient()
        mockHTTPClient.setSuccessResult(data: nullValuesJSON)
        let dataSource = APICustomerTypeDataSourceImpl(httpClient: mockHTTPClient)
        
        // When
        let result = await dataSource.getCustomerTypes()
        
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
    func testGetCustomerTypesMakesOnlyOneHTTPRequest() async throws {
        // Given
        let mockHTTPClient = MockHTTPClient()
        mockHTTPClient.setSuccessResult(data: validCustomerTypesJSON)
        let dataSource = APICustomerTypeDataSourceImpl(httpClient: mockHTTPClient)
        
        // When
        _ = await dataSource.getCustomerTypes()
        
        // Then
        #expect(mockHTTPClient.makeRequestCallCount == 1)
    }
    
    @Test("Should handle multiple consecutive calls correctly")
    func testGetCustomerTypesHandlesMultipleCalls() async throws {
        // Given
        let mockHTTPClient = MockHTTPClient()
        mockHTTPClient.setSuccessResult(data: validCustomerTypesJSON)
        let dataSource = APICustomerTypeDataSourceImpl(httpClient: mockHTTPClient)
        
        // When
        let result1 = await dataSource.getCustomerTypes()
        let result2 = await dataSource.getCustomerTypes()
        
        // Then
        switch (result1, result2) {
        case (.success(let types1), .success(let types2)):
            #expect(types1.count == 3)
            #expect(types2.count == 3)
            #expect(types1[0].key == types2[0].key)
        default:
            Issue.record("Expected both calls to succeed")
        }
        
        #expect(mockHTTPClient.makeRequestCallCount == 2)
    }
    
    // MARK: - Edge Cases
    
    @Test("Should handle very large JSON response")
    func testGetCustomerTypesHandlesLargeResponse() async throws {
        // Given
        var largeCustomerTypes: [[String: Any]] = []
        for i in 0..<100 {
            largeCustomerTypes.append([
                "key": "type_\(i)",
                "name": "Customer Type \(i)",
                "isDefault": i == 0
            ])
        }
        
        let largeJSON = try JSONSerialization.data(withJSONObject: largeCustomerTypes)
        let mockHTTPClient = MockHTTPClient()
        mockHTTPClient.setSuccessResult(data: largeJSON)
        let dataSource = APICustomerTypeDataSourceImpl(httpClient: mockHTTPClient)
        
        // When
        let result = await dataSource.getCustomerTypes()
        
        // Then
        switch result {
        case .success(let customerTypes):
            #expect(customerTypes.count == 100)
            #expect(customerTypes[0].key == "type_0")
            #expect(customerTypes[0].isDefault == true)
            #expect(customerTypes[1].isDefault == false)
        case .failure:
            Issue.record("Expected success but got failure")
        }
    }
    
}
