//
//  APICategoriesDataSource.swift
//  fly-shop
//
//  Created by Olga Covaliova on 15.10.2025.
//

protocol APICategoriesDataSource {
    func getCategories() async -> Result<[CategoryDTO], HTTPClientError>
}
