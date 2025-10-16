//
//  CategoryRepository.swift
//  fly-shop
//
//  Created by Olga Covaliova on 14.10.2025.
//

protocol CategoryRepository {
    func getCategories() async -> Result<[Category], DomainError>
}
