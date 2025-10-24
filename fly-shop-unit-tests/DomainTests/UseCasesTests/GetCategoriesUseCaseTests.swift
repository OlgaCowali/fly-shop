//
//  GetCategoriesUseCaseTests.swift
//  FlyShopUnitTests
//
//  Created by Olga Covaliova on 15.10.2025.
//

import Testing
import Foundation
@testable import fly_shop

struct GetCategoriesUseCaseTests {
    
    // MARK: - Test Data
    
    private let sampleCategories = [
        Category(name: "Flies", key: "flies"),
        Category(name: "Rods", key: "rods"),
        Category(name: "Reels", key: "reels"),
        Category(name: "Lines", key: "lines")
    ]
    
    // MARK: - Success Tests
    
    @Test("Should return categories when repository returns success")
    func testExecuteReturnsCategoriesOnSuccess() async throws {
        // Given
        let mockRepository = MockCategoryRepository()
        mockRepository.getCategoriesResult = .success(sampleCategories)
        let useCase = GetCategoriesUseCase(repository: mockRepository)
        
        // When
        let result = await useCase.execute()
        
        // Then
        #expect(mockRepository.getCategoriesCallCount == 1)
        
        switch result {
        case .success(let categories):
            #expect(categories.count == 4)
            #expect(categories[0].name == "Flies")
            #expect(categories[0].key == "flies")
            #expect(categories[1].name == "Rods")
            #expect(categories[1].key == "rods")
        case .failure:
            Issue.record("Expected success but got failure")
        }
    }
    
    @Test("Should return empty categories when repository returns empty array")
    func testExecuteReturnsEmptyCategories() async throws {
        // Given
        let mockRepository = MockCategoryRepository()
        mockRepository.getCategoriesResult = .success([])
        let useCase = GetCategoriesUseCase(repository: mockRepository)
        
        // When
        let result = await useCase.execute()
        
        // Then
        #expect(mockRepository.getCategoriesCallCount == 1)
        
        switch result {
        case .success(let categories):
            #expect(categories.isEmpty)
        case .failure:
            Issue.record("Expected success but got failure")
        }
    }
    
    // MARK: - Failure Tests
    
    @Test("Should return network error when repository returns network error")
    func testExecuteReturnsNetworkError() async throws {
        // Given
        let mockRepository = MockCategoryRepository()
        mockRepository.getCategoriesResult = .failure(.network)
        let useCase = GetCategoriesUseCase(repository: mockRepository)
        
        // When
        let result = await useCase.execute()
        
        // Then
        #expect(mockRepository.getCategoriesCallCount == 1)
        
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
        let mockRepository = MockCategoryRepository()
        mockRepository.getCategoriesResult = .failure(.server)
        let useCase = GetCategoriesUseCase(repository: mockRepository)
        
        // When
        let result = await useCase.execute()
        
        // Then
        #expect(mockRepository.getCategoriesCallCount == 1)
        
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
        let mockRepository = MockCategoryRepository()
        mockRepository.getCategoriesResult = .failure(.generic)
        let useCase = GetCategoriesUseCase(repository: mockRepository)
        
        // When
        let result = await useCase.execute()
        
        // Then
        #expect(mockRepository.getCategoriesCallCount == 1)
        
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
        let mockRepository = MockCategoryRepository()
        mockRepository.getCategoriesResult = .failure(.unauthorized)
        let useCase = GetCategoriesUseCase(repository: mockRepository)
        
        // When
        let result = await useCase.execute()
        
        // Then
        #expect(mockRepository.getCategoriesCallCount == 1)
        
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
        let mockRepository = MockCategoryRepository()
        mockRepository.getCategoriesResult = .failure(.notFound)
        let useCase = GetCategoriesUseCase(repository: mockRepository)
        
        // When
        let result = await useCase.execute()
        
        // Then
        #expect(mockRepository.getCategoriesCallCount == 1)
        
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
        let mockRepository = MockCategoryRepository()
        mockRepository.getCategoriesResult = .failure(.decoding)
        let useCase = GetCategoriesUseCase(repository: mockRepository)
        
        // When
        let result = await useCase.execute()
        
        // Then
        #expect(mockRepository.getCategoriesCallCount == 1)
        
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
        let mockRepository = MockCategoryRepository()
        mockRepository.getCategoriesResult = .success(sampleCategories)
        let useCase = GetCategoriesUseCase(repository: mockRepository)
        
        // When
        _ =  await useCase.execute()
        _ =  await useCase.execute()
        _ =  await useCase.execute()
        
        // Then
        #expect(mockRepository.getCategoriesCallCount == 3)
    }
    
    @Test("Should maintain category order from repository")
    func testMaintainsCategoryOrder() async throws {
        // Given
        let orderedCategories = [
            Category(name: "First", key: "first"),
            Category(name: "Second", key: "second"),
            Category(name: "Third", key: "third")
        ]
        let mockRepository = MockCategoryRepository()
        mockRepository.getCategoriesResult = .success(orderedCategories)
        let useCase = GetCategoriesUseCase(repository: mockRepository)
        
        // When
        let result =  await useCase.execute()
        
        // Then
        switch result {
        case .success(let categories):
            #expect(categories.count == 3)
            #expect(categories[0].name == "First")
            #expect(categories[1].name == "Second")
            #expect(categories[2].name == "Third")
        case .failure:
            Issue.record("Expected success but got failure")
        }
    }
    
    // MARK: - Edge Cases
    
    @Test("Should handle single category correctly")
    func testHandlesSingleCategory() async throws {
        // Given
        let singleCategory = [Category(name: "Solo", key: "solo")]
        let mockRepository = MockCategoryRepository()
        mockRepository.getCategoriesResult = .success(singleCategory)
        let useCase = GetCategoriesUseCase(repository: mockRepository)
        
        // When
        let result =  await useCase.execute()
        
        // Then
        switch result {
        case .success(let categories):
            #expect(categories.count == 1)
            #expect(categories[0].name == "Solo")
            #expect(categories[0].key == "solo")
        case .failure:
            Issue.record("Expected success but got failure")
        }
    }
}
