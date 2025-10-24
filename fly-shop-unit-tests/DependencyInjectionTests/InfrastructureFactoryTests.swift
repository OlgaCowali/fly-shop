//
//  InfrastructureFactoryTests.swift
//  FlyShopUnitTests
//
//  Created by Olga Covaliova on 18.10.2025.
//

import Testing
import Foundation
@testable import fly_shop

struct InfrastructureFactoryTests {
    
    // MARK: - HTTP Client Creation Tests
    
    @Test("Should create HTTP client")
    func testMakeHTTPClient() {
        // Given
        let factory = InfrastructureFactory()
        
        // When
        let httpClient = factory.makeHTTPClient()
        
        // Then
        #expect(httpClient is HTTPClient)
    }
    
    @Test("Should return same HTTP client instance on multiple calls")
    func testReturnsSameHTTPClientInstance() {
        // Given
        let factory = InfrastructureFactory()
        
        // When
        let firstCall = factory.makeHTTPClient()
        let secondCall = factory.makeHTTPClient()
        
        // Then
        #expect(ObjectIdentifier(firstCall as AnyObject) == ObjectIdentifier(secondCall as AnyObject))
    }
    
    
    // MARK: - Factory Instance Tests
    
    @Test("Should handle multiple factory instances")
    func testMultipleFactoryInstances() {
        // Given
        let factory1 = InfrastructureFactory()
        let factory2 = InfrastructureFactory()
        
        // When
        let httpClient1 = factory1.makeHTTPClient()
        let httpClient2 = factory2.makeHTTPClient()
        
        // Then
        #expect(httpClient1 is HTTPClient)
        #expect(httpClient2 is HTTPClient)
        #expect(ObjectIdentifier(httpClient1 as AnyObject) != ObjectIdentifier(httpClient2 as AnyObject))
    }
}
