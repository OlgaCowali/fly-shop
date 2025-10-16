//
//  APIProductsDataSource.swift
//  fly-shop
//
//  Created by Olga Covaliova on 15.10.2025.
//

protocol APIProductsDataSource {
    func getProducts(for customerType: CustomerType, category: Category?) async -> Result<[ProductDTO], HTTPClientError>
}
