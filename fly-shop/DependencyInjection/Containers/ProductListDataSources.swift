//
//  ProductListDataSources.swift
//  fly-shop
//
//  Created by Olga Covaliova on 18.10.2025.
//

import Foundation

// Container struct that holds all data source dependencies for the product list feature
struct ProductListDataSources {
    let customerType: APICustomerTypeDataSource
    let category: APICategoriesDataSource
    let product: APIProductsDataSource
}
