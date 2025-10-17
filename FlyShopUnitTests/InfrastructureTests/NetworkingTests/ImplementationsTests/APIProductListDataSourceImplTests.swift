//
//  APIProductListDataSourceImplTests.swift
//  FlyShopUnitTests
//
//  Created by Olga Covaliova on 16.10.2025.
//

import Testing
import Foundation
@testable import fly_shop

struct APIProductListDataSourceImplTests {
    
    // MARK: - Test Data
    
    private let validProductsJSON = """
    [
        {
            "name": "Fly Rod 1",
            "imageURL": "fly_rod_1.jpg",
            "category": {
                "key": "rods",
                "name": "Rods"
            },
            "prices": {
                "individual": 299.99,
                "business": 249.99,
                "wholesale": 199.99
            }
        },
        {
            "name": "Fly Reel 1",
            "imageURL": "fly_reel_1.jpg",
            "category": {
                "key": "reels",
                "name": "Reels"
            },
            "prices": {
                "individual": 199.99,
                "business": 169.99,
                "wholesale": 139.99
            }
        }
    ]
    """.data(using: .utf8)!
    
    private let validCustomerTypeDataJSON = """
    {
        "rods": [
            {
                "name": "Fly Rod 1",
                "imageURL": "fly_rod_1.jpg",
                "category": {
                    "key": "rods",
                    "name": "Rods"
                },
                "prices": {
                    "individual": 299.99,
                    "business": 249.99,
                    "wholesale": 199.99
                }
            }
        ],
        "reels": [
            {
                "name": "Fly Reel 1",
                "imageURL": "fly_reel_1.jpg",
                "category": {
                    "key": "reels",
                    "name": "Reels"
                },
                "prices": {
                    "individual": 199.99,
                    "business": 169.99,
                    "wholesale": 139.99
                }
            }
        ]
    }
    """.data(using: .utf8)!
    
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
    
    @Test("Should return success with products when API returns valid JSON for specific category")
    func testGetProductsReturnsSuccessWithValidJSONForCategory() async throws {
        // Given
        let mockHTTPClient = MockHTTPClient()
        mockHTTPClient.setSuccessResult(data: validProductsJSON)
        let mockCustomerTypeDataSource = MockAPICustomerTypeDataSource()
        
        let dataSource = APIProductListDataSourceImpl(
            customerTypeDataSource: mockCustomerTypeDataSource,
            httpClient: mockHTTPClient
        )
        
        let customerType = CustomerType(key: "individual", name: "Individual")
        let category = Category(name: "Rods", key: "rods")
        
        // When
        let result = await dataSource.getProducts(for: customerType, category: category)
        
        // Then
        switch result {
        case .success(let products):
            #expect(products.count == 2)
            #expect(products[0].name == "Fly Rod 1")
            #expect(products[0].imageURL == "fly_rod_1.jpg")
            #expect(products[0].category.name == "Rods")
            #expect(products[0].prices["individual"] == 299.99)
            #expect(products[1].name == "Fly Reel 1")
            #expect(products[1].category.name == "Reels")
        case .failure:
            Issue.record("Expected success but got failure")
        }
        
        // Verify HTTP client was called correctly
        #expect(mockHTTPClient.makeRequestCallCount == 1)
        #expect(mockHTTPClient.lastEndpoint?.method == .get)
        let expectedPath = "\(APIConstant.baseURLString)\(APIConstant.allProductsDataURL)individual/Rods"
        #expect(mockHTTPClient.lastEndpoint?.path == expectedPath)
    }
    
    @Test("Should return success with all products when API returns valid JSON for all categories")
    func testGetProductsReturnsSuccessWithValidJSONForAllCategories() async throws {
        // Given
        let mockHTTPClient = MockHTTPClient()
        mockHTTPClient.setSuccessResult(data: validCustomerTypeDataJSON)
        let mockCustomerTypeDataSource = MockAPICustomerTypeDataSource()
        
        let dataSource = APIProductListDataSourceImpl(
            customerTypeDataSource: mockCustomerTypeDataSource,
            httpClient: mockHTTPClient
        )
        
        let customerType = CustomerType(key: "business", name: "Business")
        
        // When
        let result = await dataSource.getProducts(for: customerType, category: nil)
        
        // Then
        switch result {
        case .success(let products):
            #expect(products.count == 2) // 1 rod + 1 reel
            let rodProduct = products.first { $0.name == "Fly Rod 1" }
            let reelProduct = products.first { $0.name == "Fly Reel 1" }
            #expect(rodProduct != nil)
            #expect(reelProduct != nil)
            #expect(rodProduct?.prices["business"] == 249.99)
            #expect(reelProduct?.prices["business"] == 169.99)
        case .failure:
            Issue.record("Expected success but got failure")
        }
        
        // Verify HTTP client was called correctly
        #expect(mockHTTPClient.makeRequestCallCount == 1)
        #expect(mockHTTPClient.lastEndpoint?.method == .get)
        let expectedPath = "\(APIConstant.baseURLString)\(APIConstant.allProductsDataURL)business"
        #expect(mockHTTPClient.lastEndpoint?.path == expectedPath)
    }
    
    @Test("Should use default customer type when customer type key is empty")
    func testGetProductsUsesDefaultCustomerTypeWhenKeyIsEmpty() async throws {
        // Given
        let mockHTTPClient = MockHTTPClient()
        mockHTTPClient.setSuccessResult(data: validProductsJSON)
        let mockCustomerTypeDataSource = MockAPICustomerTypeDataSource()
        
        // Set up customer type data source to return default customer type
        let customerTypeDTOs = [
            CustomerTypeDTO(key: "wholesale", name: "Wholesale", isDefault: true),
            CustomerTypeDTO(key: "individual", name: "Individual", isDefault: false)
        ]
        mockCustomerTypeDataSource.getCustomerTypesResult = .success(customerTypeDTOs)
        
        let dataSource = APIProductListDataSourceImpl(
            customerTypeDataSource: mockCustomerTypeDataSource,
            httpClient: mockHTTPClient
        )
        
        let customerType = CustomerType(key: "", name: "Empty") // Empty key should trigger default lookup
        let category = Category(name: "Rods", key: "rods")
        
        // When
        let result = await dataSource.getProducts(for: customerType, category: category)
        
        // Then
        switch result {
        case .success(let products):
            #expect(products.count == 2)
        case .failure:
            Issue.record("Expected success but got failure")
        }
        
        // Verify customer type data source was called
        #expect(mockCustomerTypeDataSource.getCustomerTypesCallCount == 1)
        
        // Verify HTTP client was called with default customer type
        #expect(mockHTTPClient.makeRequestCallCount == 1)
        let expectedPath = "\(APIConstant.baseURLString)\(APIConstant.allProductsDataURL)wholesale/Rods"
        #expect(mockHTTPClient.lastEndpoint?.path == expectedPath)
    }
    
    @Test("Should fallback to first customer type when no default is found")
    func testGetProductsFallsBackToFirstCustomerTypeWhenNoDefault() async throws {
        // Given
        let mockHTTPClient = MockHTTPClient()
        mockHTTPClient.setSuccessResult(data: validProductsJSON)
        let mockCustomerTypeDataSource = MockAPICustomerTypeDataSource()
        
        // Set up customer type data source with no default
        let customerTypeDTOs = [
            CustomerTypeDTO(key: "business", name: "Business", isDefault: false),
            CustomerTypeDTO(key: "individual", name: "Individual", isDefault: false)
        ]
        mockCustomerTypeDataSource.getCustomerTypesResult = .success(customerTypeDTOs)
        
        let dataSource = APIProductListDataSourceImpl(
            customerTypeDataSource: mockCustomerTypeDataSource,
            httpClient: mockHTTPClient
        )
        
        let customerType = CustomerType(key: "", name: "Empty")
        let category = Category(name: "Rods", key: "rods")
        
        // When
        let result = await dataSource.getProducts(for: customerType, category: category)
        
        // Then
        switch result {
        case .success(let products):
            #expect(products.count == 2)
        case .failure:
            Issue.record("Expected success but got failure")
        }
        
        // Verify HTTP client was called with first customer type
        #expect(mockHTTPClient.makeRequestCallCount == 1)
        let expectedPath = "\(APIConstant.baseURLString)\(APIConstant.allProductsDataURL)business/Rods"
        #expect(mockHTTPClient.lastEndpoint?.path == expectedPath)
    }
    
    @Test("Should fallback to hardcoded default when customer type API fails")
    func testGetProductsFallsBackToHardcodedDefaultWhenAPIFails() async throws {
        // Given
        let mockHTTPClient = MockHTTPClient()
        mockHTTPClient.setSuccessResult(data: validProductsJSON)
        let mockCustomerTypeDataSource = MockAPICustomerTypeDataSource()
        
        // Set up customer type data source to fail
        mockCustomerTypeDataSource.getCustomerTypesResult = .failure(HTTPClientError.generic)
        
        let dataSource = APIProductListDataSourceImpl(
            customerTypeDataSource: mockCustomerTypeDataSource,
            httpClient: mockHTTPClient
        )
        
        let customerType = CustomerType(key: "", name: "Empty")
        let category = Category(name: "Rods", key: "rods")
        
        // When
        let result = await dataSource.getProducts(for: customerType, category: category)
        
        // Then
        switch result {
        case .success(let products):
            #expect(products.count == 2)
        case .failure:
            Issue.record("Expected success but got failure")
        }
        
        // Verify HTTP client was called with hardcoded default
        #expect(mockHTTPClient.makeRequestCallCount == 1)
        let expectedPath = "\(APIConstant.baseURLString)\(APIConstant.allProductsDataURL)retail/Rods"
        #expect(mockHTTPClient.lastEndpoint?.path == expectedPath)
    }
    
    @Test("Should return empty array when API returns empty JSON array")
    func testGetProductsReturnsEmptyArrayWhenAPIReturnsEmptyArray() async throws {
        // Given
        let mockHTTPClient = MockHTTPClient()
        mockHTTPClient.setSuccessResult(data: emptyArrayJSON)
        let mockCustomerTypeDataSource = MockAPICustomerTypeDataSource()
        
        let dataSource = APIProductListDataSourceImpl(
            customerTypeDataSource: mockCustomerTypeDataSource,
            httpClient: mockHTTPClient
        )
        
        let customerType = CustomerType(key: "individual", name: "Individual")
        let category = Category(name: "Rods", key: "rods")
        
        // When
        let result = await dataSource.getProducts(for: customerType, category: category)
        
        // Then
        switch result {
        case .success(let products):
            #expect(products.isEmpty)
        case .failure:
            Issue.record("Expected success but got failure")
        }
    }
    
    // MARK: - Error Tests
    
    @Test("Should return parsing error when API returns invalid JSON for category")
    func testGetProductsReturnsParsingErrorForInvalidJSONWithCategory() async throws {
        // Given
        let mockHTTPClient = MockHTTPClient()
        mockHTTPClient.setSuccessResult(data: invalidJSON)
        let mockCustomerTypeDataSource = MockAPICustomerTypeDataSource()
        
        let dataSource = APIProductListDataSourceImpl(
            customerTypeDataSource: mockCustomerTypeDataSource,
            httpClient: mockHTTPClient
        )
        
        let customerType = CustomerType(key: "individual", name: "Individual")
        let category = Category(name: "Rods", key: "rods")
        
        // When
        let result = await dataSource.getProducts(for: customerType, category: category)
        
        // Then
        switch result {
        case .success:
            Issue.record("Expected failure but got success")
        case .failure(let error):
            #expect(error == .parsingError)
        }
    }
    
    @Test("Should return client error when HTTP client returns client error")
    func testGetProductsReturnsClientError() async throws {
        // Given
        let mockHTTPClient = MockHTTPClient()
        mockHTTPClient.setFailureResult(error: .clientError)
        let mockCustomerTypeDataSource = MockAPICustomerTypeDataSource()
        
        let dataSource = APIProductListDataSourceImpl(
            customerTypeDataSource: mockCustomerTypeDataSource,
            httpClient: mockHTTPClient
        )
        
        let customerType = CustomerType(key: "individual", name: "Individual")
        let category = Category(name: "Rods", key: "rods")
        
        // When
        let result = await dataSource.getProducts(for: customerType, category: category)
        
        // Then
        switch result {
        case .success:
            Issue.record("Expected failure but got success")
        case .failure(let error):
            #expect(error == .clientError)
        }
    }
    
    @Test("Should return server error when HTTP client returns server error")
    func testGetProductsReturnsServerError() async throws {
        // Given
        let mockHTTPClient = MockHTTPClient()
        mockHTTPClient.setFailureResult(error: .serverError)
        let mockCustomerTypeDataSource = MockAPICustomerTypeDataSource()
        
        let dataSource = APIProductListDataSourceImpl(
            customerTypeDataSource: mockCustomerTypeDataSource,
            httpClient: mockHTTPClient
        )
        
        let customerType = CustomerType(key: "individual", name: "Individual")
        
        // When
        let result = await dataSource.getProducts(for: customerType, category: nil)
        
        // Then
        switch result {
        case .success:
            Issue.record("Expected failure but got success")
        case .failure(let error):
            #expect(error == .serverError)
        }
    }
    
    @Test("Should return response error when HTTP client returns response error")
    func testGetProductsReturnsResponseError() async throws {
        // Given
        let mockHTTPClient = MockHTTPClient()
        mockHTTPClient.setFailureResult(error: .responseError)
        let mockCustomerTypeDataSource = MockAPICustomerTypeDataSource()
        
        let dataSource = APIProductListDataSourceImpl(
            customerTypeDataSource: mockCustomerTypeDataSource,
            httpClient: mockHTTPClient
        )
        
        let customerType = CustomerType(key: "individual", name: "Individual")
        let category = Category(name: "Rods", key: "rods")
        
        // When
        let result = await dataSource.getProducts(for: customerType, category: category)
        
        // Then
        switch result {
        case .success:
            Issue.record("Expected failure but got success")
        case .failure(let error):
            #expect(error == .responseError)
        }
    }
    
    @Test("Should handle empty data response")
    func testGetProductsHandlesEmptyData() async throws {
        // Given
        let emptyData = Data()
        let mockHTTPClient = MockHTTPClient()
        mockHTTPClient.setSuccessResult(data: emptyData)
        let mockCustomerTypeDataSource = MockAPICustomerTypeDataSource()
        
        let dataSource = APIProductListDataSourceImpl(
            customerTypeDataSource: mockCustomerTypeDataSource,
            httpClient: mockHTTPClient
        )
        
        let customerType = CustomerType(key: "individual", name: "Individual")
        let category = Category(name: "Rods", key: "rods")
        
        // When
        let result = await dataSource.getProducts(for: customerType, category: category)
        
        // Then
        switch result {
        case .success:
            Issue.record("Expected failure but got success")
        case .failure(let error):
            #expect(error == .parsingError)
        }
    }
    
    @Test("Should handle malformed JSON with missing required fields")
    func testGetProductsHandlesMalformedJSON() async throws {
        // Given
        let malformedJSON = """
        [
            {
                "name": "Fly Rod 1",
                "imageURL": "fly_rod_1.jpg"
            }
        ]
        """.data(using: .utf8)!
        
        let mockHTTPClient = MockHTTPClient()
        mockHTTPClient.setSuccessResult(data: malformedJSON)
        let mockCustomerTypeDataSource = MockAPICustomerTypeDataSource()
        
        let dataSource = APIProductListDataSourceImpl(
            customerTypeDataSource: mockCustomerTypeDataSource,
            httpClient: mockHTTPClient
        )
        
        let customerType = CustomerType(key: "individual", name: "Individual")
        let category = Category(name: "Rods", key: "rods")
        
        // When
        let result = await dataSource.getProducts(for: customerType, category: category)
        
        // Then
        switch result {
        case .success:
            Issue.record("Expected failure but got success")
        case .failure(let error):
            #expect(error == .parsingError)
        }
    }
    
    // MARK: - Edge Cases
    
    @Test("Should handle very large JSON response")
    func testGetProductsHandlesLargeResponse() async throws {
        // Given
        var largeProducts: [[String: Any]] = []
        for i in 0..<100 {
            largeProducts.append([
                "name": "Product \(i)",
                "imageURL": "product_\(i).jpg",
                "category": [
                    "key": "category_\(i % 5)",
                    "name": "Category \(i % 5)"
                ],
                "prices": [
                    "individual": 100.0 + Double(i),
                    "business": 80.0 + Double(i),
                    "wholesale": 60.0 + Double(i)
                ]
            ])
        }
        
        let largeJSON = try JSONSerialization.data(withJSONObject: largeProducts)
        let mockHTTPClient = MockHTTPClient()
        mockHTTPClient.setSuccessResult(data: largeJSON)
        let mockCustomerTypeDataSource = MockAPICustomerTypeDataSource()
        
        let dataSource = APIProductListDataSourceImpl(
            customerTypeDataSource: mockCustomerTypeDataSource,
            httpClient: mockHTTPClient
        )
        
        let customerType = CustomerType(key: "individual", name: "Individual")
        let category = Category(name: "Test", key: "test")
        
        // When
        let result = await dataSource.getProducts(for: customerType, category: category)
        
        // Then
        switch result {
        case .success(let products):
            #expect(products.count == 100)
            #expect(products[0].name == "Product 0")
            #expect(products[99].name == "Product 99")
        case .failure:
            Issue.record("Expected success but got failure")
        }
    }
}

