//
//  ProductListRepositoryImpl.swift
//  fly-shop
//
//  Created by Olga Covaliova on 15.10.2025.
//

import Foundation

// Repository implementation mapping API data to domain `Product`
class ProductListRepositoryImpl: ProductListRepository {

    // Data source responsible for fetching product data from the remote API
    private let apiDataSource: APIProductsDataSource
    
    init(apiDataSource: APIProductsDataSource) {
        self.apiDataSource = apiDataSource
    }
    
    func getProducts(for customerType: CustomerType, category: Category?) async -> Result<[Product], DomainError> {
        let result = await apiDataSource.getProducts(for: customerType, category: category)
        
        switch result {
        case .success(let productDTOs):
            // Map transport-layer DTOs into domain entities used by the app
            let products = productDTOs.map { dto in
                // Map string currency keys to Currency enum and Decimal values
                let mappedPrices: [Currency: Decimal] = dto.prices.reduce(into: [:]) { acc, entry in
                    if let currency = Currency(rawValue: entry.key) {
                        acc[currency] = entry.value
                    }
                }
                
                return Product(
                    name: dto.name,
                    prices: mappedPrices,
                    imageURL: dto.imageURL,
                    category: Category(name: dto.category.name, key: dto.category.key),
                    customerType: customerType
                )
            }
            return .success(products)
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
