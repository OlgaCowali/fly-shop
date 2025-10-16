//
//  AIPCategoriesSataSourceImpl.swift
//  fly-shop
//
//  Created by Olga Covaliova on 14.10.2025.
//

import Foundation

class AIPCategoriesSataSourceImpl: APICategoriesDataSource {
    
    private let httpClient = HTTPClient()
    private let catigoriesURL: String = APIConstant.baseURLString + APIConstant.productCategoryURL
    
    func getCategories() async -> Result<[CategoryDTO], HTTPClientError> {
        // Fetch categories from the API
        let result = await httpClient.makeRequest(endpoint: Endpoint(method: .get, path: catigoriesURL))
        
        guard case .success(let data) = result else {
            guard case .failure(let error) = result else {
                return .failure(.generic)
            }

            return .failure(error)
        }
        
        guard let categoryDTOs = try? JSONDecoder().decode([CategoryDTO].self, from: data) else {
            return .failure(.parsingError)
        }
        
        return .success(categoryDTOs)
    }
}


