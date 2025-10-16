//
//  CustomerTypeRepositoryImpl.swift
//  fly-shop
//
//  Created by Olga Covaliova on 15.10.2025.
//

import Foundation

// Repository implementation mapping API data to domain `CustomerType`
class CustomerTypeRepositoryImpl: CustomerTypeRepository {

    // Data source responsible for fetching customer type data from the remote API
    private let apiDataSource: APICustomerTypeDataSource
    
    init(apiDataSource: APICustomerTypeDataSource) {
        self.apiDataSource = apiDataSource
        
    }
    
    func getCustomerTypes() async -> Result<[CustomerType], DomainError> {
        let result = await apiDataSource.getCustomerTypes()
        
        switch result {
        case .success(let customerTypeDTOs):
            // Map transport-layer DTOs into domain entities used by the app
            let customerTypes = customerTypeDTOs.map { dto in
                CustomerType(key: dto.key, name: dto.name, isDefault: dto.isDefault)
            }
            return .success(customerTypes)
            
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

