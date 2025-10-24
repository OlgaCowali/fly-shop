//
//  GetProductListUseCaseTests.swift
//  FlyShopUnitTests
//
//  Created by Olga Covaliova on 16.10.2025.
//

import Testing
import Foundation
@testable import fly_shop

struct GetProductListUseCaseTests {
    
    // MARK: - Test Data
    
    private let sampleCategory = Category(name: "Flies", key: "flies")
    private let sampleCustomerType = CustomerType(key: "individual", name: "Individual", isDefault: true)
    
    private let sampleProducts = [
        Product(
            name: "Dry Fly",
            prices: [.usd: 12.99, .eur: 11.99, .gbp: 10.99],
            imageURL: "https://example.com/dry-fly.jpg",
            category: Category(name: "Flies", key: "flies"),
            quantity: 10,
            customerType: CustomerType(key: "individual", name: "Individual", isDefault: true)
        ),
        Product(
            name: "Wet Fly",
            prices: [.usd: 14.99, .eur: 13.99, .gbp: 12.99],
            imageURL: "https://example.com/wet-fly.jpg",
            category: Category(name: "Flies", key: "flies"),
            quantity: 5,
            customerType: CustomerType(key: "individual", name: "Individual", isDefault: true)
        ),
        Product(
            name: "Fly Rod",
            prices: [.usd: 299.99, .eur: 279.99, .gbp: 249.99],
            imageURL: "https://example.com/fly-rod.jpg",
            category: Category(name: "Rods", key: "rods"),
            quantity: 3,
            customerType: CustomerType(key: "individual", name: "Individual", isDefault: true)
        )
    ]
    
    // MARK: - Success Tests
    
    @Test("Should return all products when repository returns success and no category filter")
    func testExecuteReturnsAllProductsOnSuccessWithoutCategoryFilter() async throws {
        // Given
        let mockRepository = MockProductListRepository()
        mockRepository.getProductsResult = .success(sampleProducts)
        let useCase = GetProductListUseCase(repository: mockRepository)
        
        // When
        let result = try await useCase.execute(for: sampleCustomerType, filteredBy: nil)
        
        // Then
        #expect(mockRepository.getProductsCallCount == 1)
        #expect(mockRepository.lastCustomerType == sampleCustomerType)
        #expect(mockRepository.lastCategory == nil)
        
        switch result {
        case .success(let products):
            #expect(products.count == 3)
            #expect(products[0].name == "Dry Fly")
            #expect(products[1].name == "Wet Fly")
            #expect(products[2].name == "Fly Rod")
        case .failure:
            Issue.record("Expected success but got failure")
        }
    }
    
    @Test("Should return filtered products when repository returns success with category filter")
    func testExecuteReturnsFilteredProductsOnSuccessWithCategoryFilter() async throws {
        // Given
        let mockRepository = MockProductListRepository()
        mockRepository.getProductsResult = .success(sampleProducts)
        let useCase = GetProductListUseCase(repository: mockRepository)
        let fliesCategory = Category(name: "Flies", key: "flies")
        
        // When
        let result = try await useCase.execute(for: sampleCustomerType, filteredBy: fliesCategory)
        
        // Then
        #expect(mockRepository.getProductsCallCount == 1)
        #expect(mockRepository.lastCustomerType == sampleCustomerType)
        #expect(mockRepository.lastCategory == fliesCategory)
        
        switch result {
        case .success(let products):
            #expect(products.count == 2)
            #expect(products[0].name == "Dry Fly")
            #expect(products[1].name == "Wet Fly")
            #expect(products.allSatisfy { $0.category == fliesCategory })
        case .failure:
            Issue.record("Expected success but got failure")
        }
    }
    
    @Test("Should return empty products when repository returns empty array")
    func testExecuteReturnsEmptyProducts() async throws {
        // Given
        let mockRepository = MockProductListRepository()
        mockRepository.getProductsResult = .success([])
        let useCase = GetProductListUseCase(repository: mockRepository)
        
        // When
        let result = try await useCase.execute(for: sampleCustomerType, filteredBy: nil)
        
        // Then
        #expect(mockRepository.getProductsCallCount == 1)
        
        switch result {
        case .success(let products):
            #expect(products.isEmpty)
        case .failure:
            Issue.record("Expected success but got failure")
        }
    }
    
    @Test("Should return empty products when category filter matches no products")
    func testExecuteReturnsEmptyProductsWhenCategoryFilterMatchesNone() async throws {
        // Given
        let mockRepository = MockProductListRepository()
        mockRepository.getProductsResult = .success(sampleProducts)
        let useCase = GetProductListUseCase(repository: mockRepository)
        let nonMatchingCategory = Category(name: "Lines", key: "lines")
        
        // When
        let result = try await useCase.execute(for: sampleCustomerType, filteredBy: nonMatchingCategory)
        
        // Then
        #expect(mockRepository.getProductsCallCount == 1)
        
        switch result {
        case .success(let products):
            #expect(products.isEmpty)
        case .failure:
            Issue.record("Expected success but got failure")
        }
    }
    
    // MARK: - Failure Tests
    
    @Test("Should return network error when repository returns network error")
    func testExecuteReturnsNetworkError() async throws {
        // Given
        let mockRepository = MockProductListRepository()
        mockRepository.getProductsResult = .failure(.network)
        let useCase = GetProductListUseCase(repository: mockRepository)
        
        // When
        let result = try await useCase.execute(for: sampleCustomerType, filteredBy: nil)
        
        // Then
        #expect(mockRepository.getProductsCallCount == 1)
        
        switch result {
        case .success:
            Issue.record("Expected failure but got success")
        case .failure(let error):
            #expect(error == .network)
        }
    }
    
    @Test("Should return server error when repository returns server error")
    func testExecuteReturnsServerError() async throws {
        // Given
        let mockRepository = MockProductListRepository()
        mockRepository.getProductsResult = .failure(.server)
        let useCase = GetProductListUseCase(repository: mockRepository)
        
        // When
        let result = try await useCase.execute(for: sampleCustomerType, filteredBy: nil)
        
        // Then
        #expect(mockRepository.getProductsCallCount == 1)
        
        switch result {
        case .success:
            Issue.record("Expected failure but got success")
        case .failure(let error):
            #expect(error == .server)
        }
    }
    
    @Test("Should return generic error when repository returns generic error")
    func testExecuteReturnsGenericError() async throws {
        // Given
        let mockRepository = MockProductListRepository()
        mockRepository.getProductsResult = .failure(.generic)
        let useCase = GetProductListUseCase(repository: mockRepository)
        
        // When
        let result = try await useCase.execute(for: sampleCustomerType, filteredBy: nil)
        
        // Then
        #expect(mockRepository.getProductsCallCount == 1)
        
        switch result {
        case .success:
            Issue.record("Expected failure but got success")
        case .failure(let error):
            #expect(error == .generic)
        }
    }
    
    @Test("Should return unauthorized error when repository returns unauthorized error")
    func testExecuteReturnsUnauthorizedError() async throws {
        // Given
        let mockRepository = MockProductListRepository()
        mockRepository.getProductsResult = .failure(.unauthorized)
        let useCase = GetProductListUseCase(repository: mockRepository)
        
        // When
        let result = try await useCase.execute(for: sampleCustomerType, filteredBy: nil)
        
        // Then
        #expect(mockRepository.getProductsCallCount == 1)
        
        switch result {
        case .success:
            Issue.record("Expected failure but got success")
        case .failure(let error):
            #expect(error == .unauthorized)
        }
    }
    
    @Test("Should return not found error when repository returns not found error")
    func testExecuteReturnsNotFoundError() async throws {
        // Given
        let mockRepository = MockProductListRepository()
        mockRepository.getProductsResult = .failure(.notFound)
        let useCase = GetProductListUseCase(repository: mockRepository)
        
        // When
        let result = try await useCase.execute(for: sampleCustomerType, filteredBy: nil)
        
        // Then
        #expect(mockRepository.getProductsCallCount == 1)
        
        switch result {
        case .success:
            Issue.record("Expected failure but got success")
        case .failure(let error):
            #expect(error == .notFound)
        }
    }
    
    @Test("Should return decoding error when repository returns decoding error")
    func testExecuteReturnsDecodingError() async throws {
        // Given
        let mockRepository = MockProductListRepository()
        mockRepository.getProductsResult = .failure(.decoding)
        let useCase = GetProductListUseCase(repository: mockRepository)
        
        // When
        let result = try await useCase.execute(for: sampleCustomerType, filteredBy: nil)
        
        // Then
        #expect(mockRepository.getProductsCallCount == 1)
        
        switch result {
        case .success:
            Issue.record("Expected failure but got success")
        case .failure(let error):
            #expect(error == .decoding)
        }
    }
    
    // MARK: - Integration Tests
    
    @Test("Should call repository exactly once per execution")
    func testRepositoryCalledExactlyOnce() async throws {
        // Given
        let mockRepository = MockProductListRepository()
        mockRepository.getProductsResult = .success(sampleProducts)
        let useCase = GetProductListUseCase(repository: mockRepository)
        
        // When
        _ = try await useCase.execute(for: sampleCustomerType, filteredBy: nil)
        _ = try await useCase.execute(for: sampleCustomerType, filteredBy: sampleCategory)
        _ = try await useCase.execute(for: sampleCustomerType, filteredBy: nil)
        
        // Then
        #expect(mockRepository.getProductsCallCount == 3)
    }
    
    @Test("Should pass correct parameters to repository")
    func testPassesCorrectParametersToRepository() async throws {
        // Given
        let mockRepository = MockProductListRepository()
        mockRepository.getProductsResult = .success([])
        let useCase = GetProductListUseCase(repository: mockRepository)
        let customerType = CustomerType(key: "business", name: "Business", isDefault: false)
        let category = Category(name: "Rods", key: "rods")
        
        // When
        _ = try await useCase.execute(for: customerType, filteredBy: category)
        
        // Then
        #expect(mockRepository.lastCustomerType == customerType)
        #expect(mockRepository.lastCategory == category)
    }
    
    @Test("Should maintain product order from repository")
    func testMaintainsProductOrder() async throws {
        // Given
        let orderedProducts = [
            Product(
                name: "First Product",
                prices: [.usd: 10.0],
                imageURL: "https://example.com/first.jpg",
                category: sampleCategory,
                customerType: sampleCustomerType
            ),
            Product(
                name: "Second Product",
                prices: [.usd: 20.0],
                imageURL: "https://example.com/second.jpg",
                category: sampleCategory,
                customerType: sampleCustomerType
            ),
            Product(
                name: "Third Product",
                prices: [.usd: 30.0],
                imageURL: "https://example.com/third.jpg",
                category: sampleCategory,
                customerType: sampleCustomerType
            )
        ]
        let mockRepository = MockProductListRepository()
        mockRepository.getProductsResult = .success(orderedProducts)
        let useCase = GetProductListUseCase(repository: mockRepository)
        
        // When
        let result = try await useCase.execute(for: sampleCustomerType, filteredBy: nil)
        
        // Then
        switch result {
        case .success(let products):
            #expect(products.count == 3)
            #expect(products[0].name == "First Product")
            #expect(products[1].name == "Second Product")
            #expect(products[2].name == "Third Product")
        case .failure:
            Issue.record("Expected success but got failure")
        }
    }
    
    @Test("Should preserve product properties correctly")
    func testPreservesProductProperties() async throws {
        // Given
        let product = Product(
            name: "Test Product",
            prices: [.usd: 25.99, .eur: 23.99, .gbp: 21.99],
            imageURL: "https://example.com/test.jpg",
            category: sampleCategory,
            quantity: 5,
            customerType: sampleCustomerType
        )
        let mockRepository = MockProductListRepository()
        mockRepository.getProductsResult = .success([product])
        let useCase = GetProductListUseCase(repository: mockRepository)
        
        // When
        let result = try await useCase.execute(for: sampleCustomerType, filteredBy: nil)
        
        // Then
        switch result {
        case .success(let products):
            #expect(products.count == 1)
            let returnedProduct = products[0]
            #expect(returnedProduct.name == "Test Product")
            #expect(returnedProduct.prices[.usd] == 25.99)
            #expect(returnedProduct.prices[.eur] == 23.99)
            #expect(returnedProduct.prices[.gbp] == 21.99)
            #expect(returnedProduct.imageURL == "https://example.com/test.jpg")
            #expect(returnedProduct.category == sampleCategory)
            #expect(returnedProduct.quantity == 5)
            #expect(returnedProduct.customerType == sampleCustomerType)
        case .failure:
            Issue.record("Expected success but got failure")
        }
    }
    
    @Test("Should handle category filtering with multiple categories")
    func testHandlesCategoryFilteringWithMultipleCategories() async throws {
        // Given
        let fliesCategory = Category(name: "Flies", key: "flies")
        let rodsCategory = Category(name: "Rods", key: "rods")
        let mixedProducts = [
            Product(
                name: "Fly 1",
                prices: [.usd: 10.0],
                imageURL: "https://example.com/fly1.jpg",
                category: fliesCategory,
                customerType: sampleCustomerType
            ),
            Product(
                name: "Rod 1",
                prices: [.usd: 200.0],
                imageURL: "https://example.com/rod1.jpg",
                category: rodsCategory,
                customerType: sampleCustomerType
            ),
            Product(
                name: "Fly 2",
                prices: [.usd: 15.0],
                imageURL: "https://example.com/fly2.jpg",
                category: fliesCategory,
                customerType: sampleCustomerType
            )
        ]
        let mockRepository = MockProductListRepository()
        mockRepository.getProductsResult = .success(mixedProducts)
        let useCase = GetProductListUseCase(repository: mockRepository)
        
        // When
        let result = try await useCase.execute(for: sampleCustomerType, filteredBy: fliesCategory)
        
        // Then
        switch result {
        case .success(let products):
            #expect(products.count == 2)
            #expect(products[0].name == "Fly 1")
            #expect(products[1].name == "Fly 2")
            #expect(products.allSatisfy { $0.category == fliesCategory })
        case .failure:
            Issue.record("Expected success but got failure")
        }
    }
}
