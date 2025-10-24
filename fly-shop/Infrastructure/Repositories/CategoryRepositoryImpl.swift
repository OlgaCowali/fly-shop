//
//  CategoryRepositoryImpl.swift
//  fly-shop
//
//  Created by Olga Covaliova on 15.10.2025.
//

import Foundation

// Repository implementation mapping API data to domain `Category`
class CategoryRepositoryImpl: CategoryRepository {

    // Data source responsible for fetching category data from the remote API
    private let apiDataSource: APICategoriesDataSource
    
    init(apiDataSource: APICategoriesDataSource) {
        self.apiDataSource = apiDataSource
    }
    
    func getCategories() async -> Result<[Category], DomainError> {
        let result = await apiDataSource.getCategories()
        
        switch result {
        case .success(let categoryDTOs):
            // Map transport-layer DTOs into domain entities used by the app
            let categories = categoryDTOs.map { categoryDTO in
                Category(name: categoryDTO.name, key: categoryDTO.key)
            }
            return .success(categories)
            
        case .failure(let httpError):
            let domain: DomainError
            switch httpError {
            case .clientError:  domain = .network
            case .serverError:  domain = .server
            case .parsingError: domain = .decoding
            case .responseError:domain = .network
            case .generic:      domain = .generic
            }
            return .failure(domain)
        }
    }
}
