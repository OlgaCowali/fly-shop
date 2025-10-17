//
//  ProductListRepositoryImplTests.swift
//  FlyShopUnitTests
//
//  Created by Olga Covaliova on 16.10.2025.
//

import Testing
import Foundation
@testable import fly_shop

struct ProductListRepositoryImplTests {
    
    // MARK: - Test Data
    
    private let sampleCustomerType = CustomerType(key: "individual", name: "Individual", isDefault: true)
    private let sampleCategory = fly_shop.Category(name: "Flies", key: "flies")
    
    private let sampleProductDTOs = [
        ProductDTO(
            name: "Dry Fly",
            imageName: "dry_fly.jpg",
            category: CategoryDTO(key: "flies", name: "Flies"),
            prices: ["USD": 12.99, "EUR": 11.99, "GBP": 10.99]
        ),
        ProductDTO(
            name: "Wet Fly",
            imageName: "wet_fly.jpg",
            category: CategoryDTO(key: "flies", name: "Flies"),
            prices: ["USD": 15.99, "EUR": 14.99, "GBP": 13.99]
        ),
        ProductDTO(
            name: "Streamer",
            imageName: "streamer.jpg",
            category: CategoryDTO(key: "flies", name: "Flies"),
            prices: ["USD": 18.99, "EUR": 17.99, "GBP": 16.99]
        )
    ]
    
    private let expectedProducts = [
        Product(
            name: "Dry Fly",
            prices: [.usd: 12.99, .eur: 11.99, .gbp: 10.99],
            imageURL: "dry_fly.jpg",
            category: fly_shop.Category(name: "Flies", key: "flies"),
            customerType: CustomerType(key: "individual", name: "Individual", isDefault: true)
        ),
        Product(
            name: "Wet Fly",
            prices: [.usd: 15.99, .eur: 14.99, .gbp: 13.99],
            imageURL: "wet_fly.jpg",
            category: fly_shop.Category(name: "Flies", key: "flies"),
            customerType: CustomerType(key: "individual", name: "Individual", isDefault: true)
        ),
        Product(
            name: "Streamer",
            prices: [.usd: 18.99, .eur: 17.99, .gbp: 16.99],
            imageURL: "streamer.jpg",
            category: fly_shop.Category(name: "Flies", key: "flies"),
            customerType: CustomerType(key: "individual", name: "Individual", isDefault: true)
        )
    ]
    
    // MARK: - Success Tests
    
    @Test("Should return mapped products when data source returns success")
    func testGetProductsReturnsMappedProductsOnSuccess() async throws {
        // Given
        let mockDataSource = MockAPIProductsDataSource()
        mockDataSource.getProductsResult = .success(sampleProductDTOs)
        let repository = ProductListRepositoryImpl(apiDataSource: mockDataSource)
        
        // When
        let result = await repository.getProducts(for: sampleCustomerType, category: sampleCategory)
        
        // Then
        #expect(mockDataSource.getProductsCallCount == 1)
        #expect(mockDataSource.lastCustomerType == sampleCustomerType)
        #expect(mockDataSource.lastCategory == sampleCategory)
        
        switch result {
        case .success(let products):
            #expect(products.count == 3)
            
            // Verify first product
            let firstProduct = products[0]
            #expect(firstProduct.name == "Dry Fly")
            #expect(firstProduct.imageURL == "dry_fly.jpg")
            #expect(firstProduct.category.name == "Flies")
            #expect(firstProduct.category.key == "flies")
            #expect(firstProduct.customerType == sampleCustomerType)
            #expect(firstProduct.prices[.usd] == 12.99)
            #expect(firstProduct.prices[.eur] == 11.99)
            #expect(firstProduct.prices[.gbp] == 10.99)
            
            // Verify second product
            let secondProduct = products[1]
            #expect(secondProduct.name == "Wet Fly")
            #expect(secondProduct.imageURL == "wet_fly.jpg")
            #expect(secondProduct.prices[.usd] == 15.99)
            #expect(secondProduct.prices[.eur] == 14.99)
            #expect(secondProduct.prices[.gbp] == 13.99)
            
            // Verify third product
            let thirdProduct = products[2]
            #expect(thirdProduct.name == "Streamer")
            #expect(thirdProduct.imageURL == "streamer.jpg")
            #expect(thirdProduct.prices[.usd] == 18.99)
            #expect(thirdProduct.prices[.eur] == 17.99)
            #expect(thirdProduct.prices[.gbp] == 16.99)
            
        case .failure:
            Issue.record("Expected success but got failure")
        }
    }
    
    @Test("Should return empty products when data source returns empty array")
    func testGetProductsReturnsEmptyProducts() async throws {
        // Given
        let mockDataSource = MockAPIProductsDataSource()
        mockDataSource.getProductsResult = .success([])
        let repository = ProductListRepositoryImpl(apiDataSource: mockDataSource)
        
        // When
        let result = await repository.getProducts(for: sampleCustomerType, category: sampleCategory)
        
        // Then
        #expect(mockDataSource.getProductsCallCount == 1)
        
        switch result {
        case .success(let products):
            #expect(products.isEmpty)
        case .failure:
            Issue.record("Expected success but got failure")
        }
    }
    
    @Test("Should handle nil category parameter")
    func testGetProductsHandlesNilCategory() async throws {
        // Given
        let mockDataSource = MockAPIProductsDataSource()
        mockDataSource.getProductsResult = .success(sampleProductDTOs)
        let repository = ProductListRepositoryImpl(apiDataSource: mockDataSource)
        
        // When
        let result = await repository.getProducts(for: sampleCustomerType, category: nil)
        
        // Then
        #expect(mockDataSource.getProductsCallCount == 1)
        #expect(mockDataSource.lastCustomerType == sampleCustomerType)
        #expect(mockDataSource.lastCategory == nil)
        
        switch result {
        case .success(let products):
            #expect(products.count == 3)
        case .failure:
            Issue.record("Expected success but got failure")
        }
    }
    
    @Test("Should maintain product order from data source")
    func testMaintainsProductOrder() async throws {
        // Given
        let orderedDTOs = [
            ProductDTO(name: "First", imageName: "first.jpg", category: CategoryDTO(key: "test", name: "Test"), prices: ["USD": 10.0]),
            ProductDTO(name: "Second", imageName: "second.jpg", category: CategoryDTO(key: "test", name: "Test"), prices: ["USD": 20.0]),
            ProductDTO(name: "Third", imageName: "third.jpg", category: CategoryDTO(key: "test", name: "Test"), prices: ["USD": 30.0])
        ]
        let mockDataSource = MockAPIProductsDataSource()
        mockDataSource.getProductsResult = .success(orderedDTOs)
        let repository = ProductListRepositoryImpl(apiDataSource: mockDataSource)
        
        // When
        let result = await repository.getProducts(for: sampleCustomerType, category: sampleCategory)
        
        // Then
        switch result {
        case .success(let products):
            #expect(products.count == 3)
            #expect(products[0].name == "First")
            #expect(products[1].name == "Second")
            #expect(products[2].name == "Third")
        case .failure:
            Issue.record("Expected success but got failure")
        }
    }
    
    @Test("Should correctly map currency prices")
    func testCorrectlyMapsCurrencyPrices() async throws {
        // Given
        let priceDTOs = [
            ProductDTO(
                name: "Test Product",
                imageName: "test.jpg",
                category: CategoryDTO(key: "test", name: "Test"),
                prices: ["USD": 25.50, "EUR": 23.75, "GBP": 21.25]
            )
        ]
        let mockDataSource = MockAPIProductsDataSource()
        mockDataSource.getProductsResult = .success(priceDTOs)
        let repository = ProductListRepositoryImpl(apiDataSource: mockDataSource)
        
        // When
        let result = await repository.getProducts(for: sampleCustomerType, category: sampleCategory)
        
        // Then
        switch result {
        case .success(let products):
            #expect(products.count == 1)
            let product = products[0]
            #expect(product.prices[.usd] == 25.50)
            #expect(product.prices[.eur] == 23.75)
            #expect(product.prices[.gbp] == 21.25)
        case .failure:
            Issue.record("Expected success but got failure")
        }
    }
    
    // MARK: - Error Tests
    
    @Test("Should map clientError to network error")
    func testMapsClientErrorToNetworkError() async throws {
        // Given
        let mockDataSource = MockAPIProductsDataSource()
        mockDataSource.getProductsResult = .failure(.clientError)
        let repository = ProductListRepositoryImpl(apiDataSource: mockDataSource)
        
        // When
        let result = await repository.getProducts(for: sampleCustomerType, category: sampleCategory)
        
        // Then
        #expect(mockDataSource.getProductsCallCount == 1)
        
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
        let mockDataSource = MockAPIProductsDataSource()
        mockDataSource.getProductsResult = .failure(.serverError)
        let repository = ProductListRepositoryImpl(apiDataSource: mockDataSource)
        
        // When
        let result = await repository.getProducts(for: sampleCustomerType, category: sampleCategory)
        
        // Then
        #expect(mockDataSource.getProductsCallCount == 1)
        
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
        let mockDataSource = MockAPIProductsDataSource()
        mockDataSource.getProductsResult = .failure(.parsingError)
        let repository = ProductListRepositoryImpl(apiDataSource: mockDataSource)
        
        // When
        let result = await repository.getProducts(for: sampleCustomerType, category: sampleCategory)
        
        // Then
        #expect(mockDataSource.getProductsCallCount == 1)
        
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
        let mockDataSource = MockAPIProductsDataSource()
        mockDataSource.getProductsResult = .failure(.responseError)
        let repository = ProductListRepositoryImpl(apiDataSource: mockDataSource)
        
        // When
        let result = await repository.getProducts(for: sampleCustomerType, category: sampleCategory)
        
        // Then
        #expect(mockDataSource.getProductsCallCount == 1)
        
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
        let mockDataSource = MockAPIProductsDataSource()
        mockDataSource.getProductsResult = .failure(.generic)
        let repository = ProductListRepositoryImpl(apiDataSource: mockDataSource)
        
        // When
        let result = await repository.getProducts(for: sampleCustomerType, category: sampleCategory)
        
        // Then
        #expect(mockDataSource.getProductsCallCount == 1)
        
        switch result {
        case .success:
            Issue.record("Expected failure but got success")
        case .failure(let error):
            #expect(error == .generic)
        }
    }
    
    // MARK: - Edge Cases
    
    @Test("Should handle very long product names and URLs")
    func testHandlesLongProductNamesAndUrls() async throws {
        // Given
        let longName = String(repeating: "Very Long Product Name ", count: 20)
        let longURL = String(repeating: "very-long-image-url-", count: 30) + ".jpg"
        let longDTOs = [
            ProductDTO(
                name: longName,
                imageName: longURL,
                category: CategoryDTO(key: "test", name: "Test"),
                prices: ["USD": 10.0]
            )
        ]
        let mockDataSource = MockAPIProductsDataSource()
        mockDataSource.getProductsResult = .success(longDTOs)
        let repository = ProductListRepositoryImpl(apiDataSource: mockDataSource)
        
        // When
        let result = await repository.getProducts(for: sampleCustomerType, category: sampleCategory)
        
        // Then
        switch result {
        case .success(let products):
            #expect(products.count == 1)
            #expect(products[0].name == longName)
            #expect(products[0].imageURL == longURL)
        case .failure:
            Issue.record("Expected success but got failure")
        }
    }
}
