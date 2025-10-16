//
//  APICustomerTypeDataSourceImpl.swift
//  fly-shop
//
//  Created by Olga Covaliova on 15.10.2025.
//

import Foundation

class APICustomerTypeDataSourceImpl: APICustomerTypeDataSource {

    private let httpClient = HTTPClient()
    private let customerTypeURL: String = APIConstant.baseURLString + APIConstant.customerTypeURL
    
    func getCustomerTypes() async -> Result<[CustomerTypeDTO], HTTPClientError> {
        // Fetch customer types from the API
        let result = await httpClient.makeRequest(endpoint: Endpoint(method: .get, path: customerTypeURL))
        
        guard case .success(let data) = result else {
            guard case .failure(let error) = result else {
                return .failure(.generic)
            }

            return .failure(error)
        }
        
        guard let customerTypeDTOs = try? JSONDecoder().decode([CustomerTypeDTO].self, from: data) else {
            return .failure(.parsingError)
        }
        
        return .success(customerTypeDTOs)
    }
}
