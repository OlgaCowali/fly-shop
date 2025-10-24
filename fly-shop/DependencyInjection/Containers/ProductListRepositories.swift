//
//  ProductListRepositories.swift
//  fly-shop
//
//  Created by Olga Covaliova on 18.10.2025.
//

import Foundation

// Container struct that holds all repository dependencies for the product list feature
struct ProductListRepositories {
    let customerType: CustomerTypeRepository
    let category: CategoryRepository
    let product: ProductListRepository
}
