//
//  APIProductsDataSourceImpl.swift
//  fly-shop
//
//  Created by Olga Covaliova on 15.10.2025.
//

import Foundation

class APIProductsDataSourceImpl: APIProductsDataSource {
    
    private let httpClient = HTTPClient()
    
    func getProducts(for customerType: CustomerType, category: Category?) async -> Result<[ProductDTO], HTTPClientError> {
        // Build the URL with customer type parameter
        let customerTypeKey = customerType.key.isEmpty ? "retail" : customerType.key
        let baseURL = APIConstant.baseURLString + APIConstant.allCustomersProductsURL
        
        // Build query parameters for customer type and optional category
        var queryParams: [String: Any] = ["customer_type": customerTypeKey]
        
        if let category = category {
            queryParams["category"] = category.key
        }
        
        // Fetch products from the API
        let result = await httpClient.makeRequest(endpoint: Endpoint(method: .get, path: baseURL, queryParams: queryParams))
        
        guard case .success(let data) = result else {
            guard case .failure(let error) = result else {
                return .failure(.generic)
            }

            return .failure(error)
        }
        
        guard let productDTOs = try? JSONDecoder().decode([ProductDTO].self, from: data) else {
            return .failure(.parsingError)
        }
        
        return .success(productDTOs)
    }
}
