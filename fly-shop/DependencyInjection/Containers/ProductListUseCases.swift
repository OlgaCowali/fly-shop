//
//  ProductListUseCases.swift
//  fly-shop
//
//  Created by Olga Covaliova on 18.10.2025.
//

import Foundation

// Container struct that holds all use case dependencies for the product list feature
struct ProductListUseCases {
    let getCustomerTypes: GetCustomerTypes
    let getCategories: GetCategories
    let getProductList: GetProductList
}

