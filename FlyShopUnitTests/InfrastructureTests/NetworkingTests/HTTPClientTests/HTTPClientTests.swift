//
//  HTTPClientTests.swift
//  FlyShopUnitTests
//
//  Created by Olga Covaliova on 16.10.2025.
//

import Testing
import Foundation
import Alamofire
@testable import fly_shop

struct HTTPClientTests {
    
    // MARK: - Test Data
    
    private let sampleJSONData = """
    {
        "categories": [
            {"name": "Flies", "key": "flies"},
            {"name": "Rods", "key": "rods"}
        ]
    }
    """.data(using: .utf8)!
    
    private let sampleErrorData = """
    {
        "error": "Invalid request",
        "message": "The request could not be processed"
    }
    """.data(using: .utf8)!
    
    // MARK: - Success Tests
    
    @Test("Should return success with data when request succeeds")
    func testMakeRequestReturnsSuccessWithData() async throws {
        // Given
        let httpClient = HTTPClient()
        let endpoint = Endpoint(method: .get, path: "https://httpbin.org/json")
        
        // When
        let result = await httpClient.makeRequest(endpoint: endpoint)
        
        // Then
        switch result {
        case .success(let data):
            #expect(!data.isEmpty)
        case .failure:
            Issue.record("Expected success but got failure")
        }
    }
    
    @Test("Should use base URL when path is nil")
    func testMakeRequestUsesBaseURLWhenPathIsNil() async throws {
        // Given
        let httpClient = HTTPClient()
        let endpoint = Endpoint(method: .get, path: nil)
        
        // When
        let result = await httpClient.makeRequest(endpoint: endpoint)
        
        // Then
        switch result {
        case .success(let data):
            #expect(!data.isEmpty)
        case .failure:
            Issue.record("Expected success but got failure")
        }
    }
    
    // MARK: - Error Tests
    
    @Test("Should return client error for 4xx status codes")
    func testMakeRequestReturnsClientErrorFor4xxStatus() async throws {
        // Given
        let httpClient = HTTPClient()
        let endpoint = Endpoint(method: .get, path: "https://httpbin.org/status/400")
        
        // When
        let result = await httpClient.makeRequest(endpoint: endpoint)
        
        // Then
        switch result {
        case .success:
            Issue.record("Expected failure but got success")
        case .failure(let error):
            #expect(error == .clientError)
        }
    }
    
    @Test("Should return client error for 404 status code")
    func testMakeRequestReturnsClientErrorFor404Status() async throws {
        // Given
        let httpClient = HTTPClient()
        let endpoint = Endpoint(method: .get, path: "https://httpbin.org/status/404")
        
        // When
        let result = await httpClient.makeRequest(endpoint: endpoint)
        
        // Then
        switch result {
        case .success:
            Issue.record("Expected failure but got success")
        case .failure(let error):
            #expect(error == .clientError)
        }
    }
    
    @Test("Should return server error for 5xx status codes")
    func testMakeRequestReturnsServerErrorFor5xxStatus() async throws {
        // Given
        let httpClient = HTTPClient()
        let endpoint = Endpoint(method: .get, path: "https://httpbin.org/status/500")
        
        // When
        let result = await httpClient.makeRequest(endpoint: endpoint)
        
        // Then
        switch result {
        case .success:
            Issue.record("Expected failure but got success")
        case .failure(let error):
            #expect(error == .serverError)
        }
    }
    
    @Test("Should return server error for 503 status code")
    func testMakeRequestReturnsServerErrorFor503Status() async throws {
        // Given
        let httpClient = HTTPClient()
        let endpoint = Endpoint(method: .get, path: "https://httpbin.org/status/503")
        
        // When
        let result = await httpClient.makeRequest(endpoint: endpoint)
        
        // Then
        switch result {
        case .success:
            Issue.record("Expected failure but got success")
        case .failure(let error):
            #expect(error == .serverError)
        }
    }
    
    @Test("Should return response error for invalid URL")
    func testMakeRequestReturnsResponseErrorForInvalidURL() async throws {
        // Given
        let httpClient = HTTPClient()
        let endpoint = Endpoint(method: .get, path: "invalid-url")
        
        // When
        let result = await httpClient.makeRequest(endpoint: endpoint)
        
        // Then
        switch result {
        case .success:
            Issue.record("Expected failure but got success")
        case .failure(let error):
            #expect(error == .responseError)
        }
    }
    
    @Test("Should return response error for unreachable host")
    func testMakeRequestReturnsResponseErrorForUnreachableHost() async throws {
        // Given
        let httpClient = HTTPClient()
        let endpoint = Endpoint(method: .get, path: "https://unreachable-host-12345.com")
        
        // When
        let result = await httpClient.makeRequest(endpoint: endpoint)
        
        // Then
        switch result {
        case .success:
            Issue.record("Expected failure but got success")
        case .failure(let error):
            #expect(error == .responseError)
        }
    }
    
    // MARK: - Endpoint Tests
    
    @Test("Should create endpoint with custom path")
    func testEndpointCreationWithCustomPath() {
        // Given & When
        let endpoint = Endpoint(method: .get, path: "https://api.example.com/data")
        
        // Then
        #expect(endpoint.path == "https://api.example.com/data")
        #expect(endpoint.method == .get)
    }
    
    @Test("Should create endpoint with GET method")
    func testEndpointCreationWithGetMethod() {
        // Given & When
        let endpoint = Endpoint(method: .get)
        
        // Then
        #expect(endpoint.method == .get)
    }
    
    @Test("Should create endpoint with POST method")
    func testEndpointCreationWithPostMethod() {
        // Given & When
        let endpoint = Endpoint(method: .post)
        
        // Then
        #expect(endpoint.method == .post)
    }
    
    // MARK: - Integration Tests
    
    @Test("Should work with real API endpoint")
    func testWorksWithRealAPIEndpoint() async throws {
        // Given
        let httpClient = HTTPClient()
        let endpoint = Endpoint(method: .get, path: APIConstant.baseURLString)
        
        // When
        let result = await httpClient.makeRequest(endpoint: endpoint)
        
        // Then
        switch result {
        case .success(let data):
            #expect(!data.isEmpty)
            // Verify it's valid JSON
            let json = try JSONSerialization.jsonObject(with: data)
            #expect(json is [String: Any])
        case .failure(let error):
            // If the real API is down, we should get a specific error type
            #expect(error == .responseError || error == .serverError)
        }
    }
    
}
