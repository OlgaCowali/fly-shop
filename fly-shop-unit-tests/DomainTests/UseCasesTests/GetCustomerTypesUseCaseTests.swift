//
//  GetCustomerTypesUseCaseTests.swift
//  FlyShopUnitTests
//
//  Created by Olga Covaliova on 16.10.2025.
//

import Testing
import Foundation
@testable import fly_shop

struct GetCustomerTypesUseCaseTests {
    
    // MARK: - Test Data
    
    private let sampleCustomerTypes = [
        CustomerType(key: "individual", name: "Individual", isDefault: true),
        CustomerType(key: "business", name: "Business", isDefault: false),
        CustomerType(key: "wholesale", name: "Wholesale", isDefault: false),
        CustomerType(key: "retail", name: "Retail", isDefault: false)
    ]
    
    // MARK: - Success Tests
    
    @Test("Should return customer types when repository returns success")
    func testExecuteReturnsCustomerTypesOnSuccess() async throws {
        // Given
        let mockRepository = MockCustomerTypeRepository()
        mockRepository.getCustomerTypesResult = .success(sampleCustomerTypes)
        let useCase = GetCustomerTypesUseCase(repository: mockRepository)
        
        // When
        let result = await useCase.execute()
        
        // Then
        #expect(mockRepository.getCustomerTypesCallCount == 1)
        
        switch result {
        case .success(let customerTypes):
            #expect(customerTypes.count == 4)
            #expect(customerTypes[0].key == "individual")
            #expect(customerTypes[0].name == "Individual")
            #expect(customerTypes[0].isDefault == true)
            #expect(customerTypes[1].key == "business")
            #expect(customerTypes[1].name == "Business")
            #expect(customerTypes[1].isDefault == false)
        case .failure:
            Issue.record("Expected success but got failure")
        }
    }
    
    @Test("Should return empty customer types when repository returns empty array")
    func testExecuteReturnsEmptyCustomerTypes() async throws {
        // Given
        let mockRepository = MockCustomerTypeRepository()
        mockRepository.getCustomerTypesResult = .success([])
        let useCase = GetCustomerTypesUseCase(repository: mockRepository)
        
        // When
        let result = await useCase.execute()
        
        // Then
        #expect(mockRepository.getCustomerTypesCallCount == 1)
        
        switch result {
        case .success(let customerTypes):
            #expect(customerTypes.isEmpty)
        case .failure:
            Issue.record("Expected success but got failure")
        }
    }
    
    // MARK: - Failure Tests
    
    @Test("Should return network error when repository returns network error")
    func testExecuteReturnsNetworkError() async throws {
        // Given
        let mockRepository = MockCustomerTypeRepository()
        mockRepository.getCustomerTypesResult = .failure(.network)
        let useCase = GetCustomerTypesUseCase(repository: mockRepository)
        
        // When
        let result = await useCase.execute()
        
        // Then
        #expect(mockRepository.getCustomerTypesCallCount == 1)
        
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
        let mockRepository = MockCustomerTypeRepository()
        mockRepository.getCustomerTypesResult = .failure(.server)
        let useCase = GetCustomerTypesUseCase(repository: mockRepository)
        
        // When
        let result = await useCase.execute()
        
        // Then
        #expect(mockRepository.getCustomerTypesCallCount == 1)
        
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
        let mockRepository = MockCustomerTypeRepository()
        mockRepository.getCustomerTypesResult = .failure(.generic)
        let useCase = GetCustomerTypesUseCase(repository: mockRepository)
        
        // When
        let result = await useCase.execute()
        
        // Then
        #expect(mockRepository.getCustomerTypesCallCount == 1)
        
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
        let mockRepository = MockCustomerTypeRepository()
        mockRepository.getCustomerTypesResult = .failure(.unauthorized)
        let useCase = GetCustomerTypesUseCase(repository: mockRepository)
        
        // When
        let result = await useCase.execute()
        
        // Then
        #expect(mockRepository.getCustomerTypesCallCount == 1)
        
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
        let mockRepository = MockCustomerTypeRepository()
        mockRepository.getCustomerTypesResult = .failure(.notFound)
        let useCase = GetCustomerTypesUseCase(repository: mockRepository)
        
        // When
        let result = await useCase.execute()
        
        // Then
        #expect(mockRepository.getCustomerTypesCallCount == 1)
        
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
        let mockRepository = MockCustomerTypeRepository()
        mockRepository.getCustomerTypesResult = .failure(.decoding)
        let useCase = GetCustomerTypesUseCase(repository: mockRepository)
        
        // When
        let result = await useCase.execute()
        
        // Then
        #expect(mockRepository.getCustomerTypesCallCount == 1)
        
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
        let mockRepository = MockCustomerTypeRepository()
        mockRepository.getCustomerTypesResult = .success(sampleCustomerTypes)
        let useCase = GetCustomerTypesUseCase(repository: mockRepository)
        
        // When
        _ =  await useCase.execute()
        _ =  await useCase.execute()
        _ =  await useCase.execute()
        
        // Then
        #expect(mockRepository.getCustomerTypesCallCount == 3)
    }
    
    @Test("Should maintain customer type order from repository")
    func testMaintainsCustomerTypeOrder() async throws {
        // Given
        let orderedCustomerTypes = [
            CustomerType(key: "first", name: "First Type", isDefault: true),
            CustomerType(key: "second", name: "Second Type", isDefault: false),
            CustomerType(key: "third", name: "Third Type", isDefault: false)
        ]
        let mockRepository = MockCustomerTypeRepository()
        mockRepository.getCustomerTypesResult = .success(orderedCustomerTypes)
        let useCase = GetCustomerTypesUseCase(repository: mockRepository)
        
        // When
        let result =  await useCase.execute()
        
        // Then
        switch result {
        case .success(let customerTypes):
            #expect(customerTypes.count == 3)
            #expect(customerTypes[0].name == "First Type")
            #expect(customerTypes[1].name == "Second Type")
            #expect(customerTypes[2].name == "Third Type")
        case .failure:
            Issue.record("Expected success but got failure")
        }
    }
    
    // MARK: - Edge Cases
    
    @Test("Should handle single customer type correctly")
    func testHandlesSingleCustomerType() async throws {
        // Given
        let singleCustomerType = [CustomerType(key: "solo", name: "Solo Type", isDefault: true)]
        let mockRepository = MockCustomerTypeRepository()
        mockRepository.getCustomerTypesResult = .success(singleCustomerType)
        let useCase = GetCustomerTypesUseCase(repository: mockRepository)
        
        // When
        let result =  await useCase.execute()
        
        // Then
        switch result {
        case .success(let customerTypes):
            #expect(customerTypes.count == 1)
            #expect(customerTypes[0].name == "Solo Type")
            #expect(customerTypes[0].key == "solo")
            #expect(customerTypes[0].isDefault == true)
        case .failure:
            Issue.record("Expected success but got failure")
        }
    }
    
    @Test("Should handle customer types with different default values")
    func testHandlesCustomerTypesWithDifferentDefaultValues() async throws {
        // Given
        let customerTypesWithDefaults = [
            CustomerType(key: "default_true", name: "Default True", isDefault: true),
            CustomerType(key: "default_false", name: "Default False", isDefault: false)
        ]
        let mockRepository = MockCustomerTypeRepository()
        mockRepository.getCustomerTypesResult = .success(customerTypesWithDefaults)
        let useCase = GetCustomerTypesUseCase(repository: mockRepository)
        
        // When
        let result =  await useCase.execute()
        
        // Then
        switch result {
        case .success(let customerTypes):
            #expect(customerTypes.count == 2)
            #expect(customerTypes[0].isDefault == true)
            #expect(customerTypes[1].isDefault == false)
        case .failure:
            Issue.record("Expected success but got failure")
        }
    }
    
    @Test("Should preserve customer type properties correctly")
    func testPreservesCustomerTypeProperties() async throws {
        // Given
        let customerType = CustomerType(key: "test_key", name: "Test Name", isDefault: true)
        let mockRepository = MockCustomerTypeRepository()
        mockRepository.getCustomerTypesResult = .success([customerType])
        let useCase = GetCustomerTypesUseCase(repository: mockRepository)
        
        // When
        let result =  await useCase.execute()
        
        // Then
        switch result {
        case .success(let customerTypes):
            #expect(customerTypes.count == 1)
            let returnedCustomerType = customerTypes[0]
            #expect(returnedCustomerType.key == "test_key")
            #expect(returnedCustomerType.name == "Test Name")
            #expect(returnedCustomerType.isDefault == true)
            #expect(returnedCustomerType.id == "test_key") // Test computed property
        case .failure:
            Issue.record("Expected success but got failure")
        }
    }
}
