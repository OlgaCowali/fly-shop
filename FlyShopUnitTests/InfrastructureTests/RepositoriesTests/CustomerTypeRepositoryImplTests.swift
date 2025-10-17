//
//  CustomerTypeRepositoryImplTests.swift
//  FlyShopUnitTests
//
//  Created by Olga Covaliova on 16.10.2025.
//

import Testing
import Foundation
@testable import fly_shop

struct CustomerTypeRepositoryImplTests {
    
    // MARK: - Test Data
    
    private let sampleCustomerTypeDTOs = [
        CustomerTypeDTO(key: "individual", name: "Individual", isDefault: true),
        CustomerTypeDTO(key: "business", name: "Business", isDefault: false),
        CustomerTypeDTO(key: "wholesale", name: "Wholesale", isDefault: false),
        CustomerTypeDTO(key: "retail", name: "Retail", isDefault: false)
    ]
    
    private let expectedCustomerTypes = [
        CustomerType(key: "individual", name: "Individual", isDefault: true),
        CustomerType(key: "business", name: "Business", isDefault: false),
        CustomerType(key: "wholesale", name: "Wholesale", isDefault: false),
        CustomerType(key: "retail", name: "Retail", isDefault: false)
    ]
    
    // MARK: - Success Tests
    
    @Test("Should return mapped customer types when data source returns success")
    func testGetCustomerTypesReturnsMappedCustomerTypesOnSuccess() async throws {
        // Given
        let mockDataSource = MockAPICustomerTypeDataSource()
        mockDataSource.getCustomerTypesResult = .success(sampleCustomerTypeDTOs)
        let repository = CustomerTypeRepositoryImpl(apiDataSource: mockDataSource)
        
        // When
        let result = await repository.getCustomerTypes()
        
        // Then
        #expect(mockDataSource.getCustomerTypesCallCount == 1)
        
        switch result {
        case .success(let customerTypes):
            #expect(customerTypes.count == 4)
            #expect(customerTypes[0].name == "Individual")
            #expect(customerTypes[0].key == "individual")
            #expect(customerTypes[0].isDefault == true)
            #expect(customerTypes[1].name == "Business")
            #expect(customerTypes[1].key == "business")
            #expect(customerTypes[1].isDefault == false)
            #expect(customerTypes[2].name == "Wholesale")
            #expect(customerTypes[2].key == "wholesale")
            #expect(customerTypes[2].isDefault == false)
            #expect(customerTypes[3].name == "Retail")
            #expect(customerTypes[3].key == "retail")
            #expect(customerTypes[3].isDefault == false)
        case .failure:
            Issue.record("Expected success but got failure")
        }
    }
    
    @Test("Should return empty customer types when data source returns empty array")
    func testGetCustomerTypesReturnsEmptyCustomerTypes() async throws {
        // Given
        let mockDataSource = MockAPICustomerTypeDataSource()
        mockDataSource.getCustomerTypesResult = .success([])
        let repository = CustomerTypeRepositoryImpl(apiDataSource: mockDataSource)
        
        // When
        let result = await repository.getCustomerTypes()
        
        // Then
        #expect(mockDataSource.getCustomerTypesCallCount == 1)
        
        switch result {
        case .success(let customerTypes):
            #expect(customerTypes.isEmpty)
        case .failure:
            Issue.record("Expected success but got failure")
        }
    }
    
    @Test("Should maintain customer type order from data source")
    func testMaintainsCustomerTypeOrder() async throws {
        // Given
        let orderedDTOs = [
            CustomerTypeDTO(key: "first", name: "First", isDefault: true),
            CustomerTypeDTO(key: "second", name: "Second", isDefault: false),
            CustomerTypeDTO(key: "third", name: "Third", isDefault: false)
        ]
        let mockDataSource = MockAPICustomerTypeDataSource()
        mockDataSource.getCustomerTypesResult = .success(orderedDTOs)
        let repository = CustomerTypeRepositoryImpl(apiDataSource: mockDataSource)
        
        // When
        let result = await repository.getCustomerTypes()
        
        // Then
        switch result {
        case .success(let customerTypes):
            #expect(customerTypes.count == 3)
            #expect(customerTypes[0].name == "First")
            #expect(customerTypes[0].key == "first")
            #expect(customerTypes[0].isDefault == true)
            #expect(customerTypes[1].name == "Second")
            #expect(customerTypes[1].key == "second")
            #expect(customerTypes[1].isDefault == false)
            #expect(customerTypes[2].name == "Third")
            #expect(customerTypes[2].key == "third")
            #expect(customerTypes[2].isDefault == false)
        case .failure:
            Issue.record("Expected success but got failure")
        }
    }
    
    @Test("Should correctly map isDefault property")
    func testCorrectlyMapsIsDefaultProperty() async throws {
        // Given
        let mixedDefaultDTOs = [
            CustomerTypeDTO(key: "default_true", name: "Default True", isDefault: true),
            CustomerTypeDTO(key: "default_false", name: "Default False", isDefault: false)
        ]
        let mockDataSource = MockAPICustomerTypeDataSource()
        mockDataSource.getCustomerTypesResult = .success(mixedDefaultDTOs)
        let repository = CustomerTypeRepositoryImpl(apiDataSource: mockDataSource)
        
        // When
        let result = await repository.getCustomerTypes()
        
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
    
    // MARK: - Error Tests
    
    @Test("Should map clientError to network error")
    func testMapsClientErrorToNetworkError() async throws {
        // Given
        let mockDataSource = MockAPICustomerTypeDataSource()
        mockDataSource.getCustomerTypesResult = .failure(.clientError)
        let repository = CustomerTypeRepositoryImpl(apiDataSource: mockDataSource)
        
        // When
        let result = await repository.getCustomerTypes()
        
        // Then
        #expect(mockDataSource.getCustomerTypesCallCount == 1)
        
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
        let mockDataSource = MockAPICustomerTypeDataSource()
        mockDataSource.getCustomerTypesResult = .failure(.serverError)
        let repository = CustomerTypeRepositoryImpl(apiDataSource: mockDataSource)
        
        // When
        let result = await repository.getCustomerTypes()
        
        // Then
        #expect(mockDataSource.getCustomerTypesCallCount == 1)
        
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
        let mockDataSource = MockAPICustomerTypeDataSource()
        mockDataSource.getCustomerTypesResult = .failure(.parsingError)
        let repository = CustomerTypeRepositoryImpl(apiDataSource: mockDataSource)
        
        // When
        let result = await repository.getCustomerTypes()
        
        // Then
        #expect(mockDataSource.getCustomerTypesCallCount == 1)
        
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
        let mockDataSource = MockAPICustomerTypeDataSource()
        mockDataSource.getCustomerTypesResult = .failure(.responseError)
        let repository = CustomerTypeRepositoryImpl(apiDataSource: mockDataSource)
        
        // When
        let result = await repository.getCustomerTypes()
        
        // Then
        #expect(mockDataSource.getCustomerTypesCallCount == 1)
        
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
        let mockDataSource = MockAPICustomerTypeDataSource()
        mockDataSource.getCustomerTypesResult = .failure(.generic)
        let repository = CustomerTypeRepositoryImpl(apiDataSource: mockDataSource)
        
        // When
        let result = await repository.getCustomerTypes()
        
        // Then
        #expect(mockDataSource.getCustomerTypesCallCount == 1)
        
        switch result {
        case .success:
            Issue.record("Expected failure but got success")
        case .failure(let error):
            #expect(error == .generic)
        }
    }
    
    // MARK: - Edge Cases
    
    @Test("Should handle very long customer type names and keys")
    func testHandlesLongCustomerTypeNamesAndKeys() async throws {
        // Given
        let longName = String(repeating: "Very Long Customer Type Name ", count: 10)
        let longKey = String(repeating: "very-long-customer-type-key-", count: 20)
        let longDTOs = [CustomerTypeDTO(key: longKey, name: longName, isDefault: true)]
        let mockDataSource = MockAPICustomerTypeDataSource()
        mockDataSource.getCustomerTypesResult = .success(longDTOs)
        let repository = CustomerTypeRepositoryImpl(apiDataSource: mockDataSource)
        
        // When
        let result = await repository.getCustomerTypes()
        
        // Then
        switch result {
        case .success(let customerTypes):
            #expect(customerTypes.count == 1)
            #expect(customerTypes[0].name == longName)
            #expect(customerTypes[0].key == longKey)
            #expect(customerTypes[0].isDefault == true)
        case .failure:
            Issue.record("Expected success but got failure")
        }
    }
    
    @Test("Should handle special characters in names and keys")
    func testHandlesSpecialCharactersInNamesAndKeys() async throws {
        // Given
        let specialDTOs = [
            CustomerTypeDTO(key: "customer-type-with-dashes", name: "Customer Type with Dashes", isDefault: false),
            CustomerTypeDTO(key: "customer_type_with_underscores", name: "Customer Type with Underscores", isDefault: true),
            CustomerTypeDTO(key: "customerTypeWithCamelCase", name: "Customer Type with Camel Case", isDefault: false)
        ]
        let mockDataSource = MockAPICustomerTypeDataSource()
        mockDataSource.getCustomerTypesResult = .success(specialDTOs)
        let repository = CustomerTypeRepositoryImpl(apiDataSource: mockDataSource)
        
        // When
        let result = await repository.getCustomerTypes()
        
        // Then
        switch result {
        case .success(let customerTypes):
            #expect(customerTypes.count == 3)
            #expect(customerTypes[0].key == "customer-type-with-dashes")
            #expect(customerTypes[0].name == "Customer Type with Dashes")
            #expect(customerTypes[0].isDefault == false)
            #expect(customerTypes[1].key == "customer_type_with_underscores")
            #expect(customerTypes[1].name == "Customer Type with Underscores")
            #expect(customerTypes[1].isDefault == true)
            #expect(customerTypes[2].key == "customerTypeWithCamelCase")
            #expect(customerTypes[2].name == "Customer Type with Camel Case")
            #expect(customerTypes[2].isDefault == false)
        case .failure:
            Issue.record("Expected success but got failure")
        }
    }
    
    // MARK: - Integration Tests
    
    @Test("Should preserve all customer type properties during mapping")
    func testPreservesAllCustomerTypePropertiesDuringMapping() async throws {
        // Given
        let comprehensiveDTOs = [
            CustomerTypeDTO(key: "comprehensive1", name: "Comprehensive Test 1", isDefault: true),
            CustomerTypeDTO(key: "comprehensive2", name: "Comprehensive Test 2", isDefault: false)
        ]
        let mockDataSource = MockAPICustomerTypeDataSource()
        mockDataSource.getCustomerTypesResult = .success(comprehensiveDTOs)
        let repository = CustomerTypeRepositoryImpl(apiDataSource: mockDataSource)
        
        // When
        let result = await repository.getCustomerTypes()
        
        // Then
        switch result {
        case .success(let customerTypes):
            #expect(customerTypes.count == 2)
            
            // Verify first customer type
            let firstType = customerTypes[0]
            #expect(firstType.key == "comprehensive1")
            #expect(firstType.name == "Comprehensive Test 1")
            #expect(firstType.isDefault == true)
            #expect(firstType.id == "comprehensive1") // Verify computed property
            
            // Verify second customer type
            let secondType = customerTypes[1]
            #expect(secondType.key == "comprehensive2")
            #expect(secondType.name == "Comprehensive Test 2")
            #expect(secondType.isDefault == false)
            #expect(secondType.id == "comprehensive2") // Verify computed property
        case .failure:
            Issue.record("Expected success but got failure")
        }
    }
}
