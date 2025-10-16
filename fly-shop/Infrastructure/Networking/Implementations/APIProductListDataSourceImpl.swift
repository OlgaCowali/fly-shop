//
//  APIProductListDataSourceImpl.swift
//  fly-shop
//
//  Created by Olga Covaliova on 15.10.2025.
//

import Foundation

class APIProductListDataSourceImpl: APIProductsDataSource {
    
    private let httpClient = HTTPClient()
    private let baseURL = APIConstant.baseURLString
    private let allProductsURL = APIConstant.allProductsDataURL
    private let defaultCustomerType = "retail"
    
    // Dependencies for fetching customer types and categories
    private let customerTypeDataSource: APICustomerTypeDataSource
    
    init(customerTypeDataSource: APICustomerTypeDataSource, categoriesDataSource: APICategoriesDataSource) {
        self.customerTypeDataSource = customerTypeDataSource
    }
    
    func getProducts(for customerType: CustomerType, category: Category?) async -> Result<[ProductDTO], HTTPClientError> {
        // Get customer type key
        let customerTypeKey = customerType.key.isEmpty ? await getDefaultCustomerType() : customerType.key
        
        // Build the endpoint URL based on whether category is specified
        let endpointPath: String
        if let category = category {
            // Load specific category for customer type
            endpointPath = "\(baseURL)\(allProductsURL)\(customerTypeKey)/\(category.name)"
        } else {
            // Load all categories for customer type
            endpointPath = "\(baseURL)\(allProductsURL)\(customerTypeKey)"
        }
        
        let endpoint = Endpoint(method: .get, path: endpointPath)
        let result = await httpClient.makeRequest(endpoint: endpoint)
        
        switch result {
        case .success(let data):
            if let category = category {
                // Response is directly an array of ProductDTO for the specific category
                guard let products = try? JSONDecoder().decode([ProductDTO].self, from: data) else {
                    return .failure(.parsingError)
                }
                return .success(products)
            } else {
                // Response is a dictionary of categories with arrays of products
                guard let customerTypeData = try? JSONDecoder().decode([String: [ProductDTO]].self, from: data) else {
                    return .failure(.parsingError)
                }
                
                // Flatten all products from all categories
                var allProducts: [ProductDTO] = []
                for (_, products) in customerTypeData {
                    allProducts.append(contentsOf: products)
                }
                return .success(allProducts)
            }
            
        case .failure(let error):
            return .failure(error)
        }
    }
    
    private func getDefaultCustomerType() async -> String {
        let result = await customerTypeDataSource.getCustomerTypes()
        
        switch result {
        case .success(let customerTypeDTOs):
            // Find the customer type with isDefault = true
            if let defaultCustomerType = customerTypeDTOs.first(where: { $0.isDefault }) {
                return defaultCustomerType.key
            }
            // Fallback to first customer type if no default is found
            return customerTypeDTOs.first?.key ?? defaultCustomerType
        case .failure(_):
            // Fallback to hardcoded value if API fails
            return defaultCustomerType
        }
    }
}
