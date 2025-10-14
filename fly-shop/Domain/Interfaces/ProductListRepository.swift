//
//  ProductRepositoryProtocol.swift
//  fly-shop
//
//  Created by Olga Covaliova on 14.10.2025.
//

import Foundation

protocol ProductListRepository {
    func getProducts(for customerType: CustomerType) async throws -> [Product]
}

