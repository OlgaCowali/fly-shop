//
//  DataSourceFactory.swift
//  fly-shop
//
//  Created by Olga Covaliova on 18.10.2025.
//

import Foundation

// Factory responsible for creating data source implementations for API operations
final class DataSourceFactory {
    
    private let httpClient: HTTPClientProtocol
    
    init(httpClient: HTTPClientProtocol) {
        self.httpClient = httpClient
    }

    // Creates a customer type data source implementation
    func makeCustomerTypeDataSource() -> APICustomerTypeDataSource {
        APICustomerTypeDataSourceImpl(httpClient: httpClient)
    }
    
    // Creates a category data source implementation
    func makeCategoryDataSource() -> APICategoriesDataSource {
        APICategoriesDataSourceImpl(httpClient: httpClient)
    }
    
    // Creates a product data source implementation
    func makeProductDataSource() -> APIProductsDataSource {
        APIProductListDataSourceImpl(
            customerTypeDataSource: makeCustomerTypeDataSource(),
            httpClient: httpClient
        )
    }
    
    // Creates a payment data source implementation
    func makePaymentDataSource() -> APIPaymentDataSource {
        APIPaymentDataSourceImpl(httpClient: httpClient)
    }
    
    // Creates a container with all data sources needed for the product list feature
    func makeProductListDataSources() -> ProductListDataSources {
        let customerTypeDataSource = makeCustomerTypeDataSource()
        let categoryDataSource = makeCategoryDataSource()
        let productDataSource = makeProductDataSource()
        
        return ProductListDataSources(
            customerType: customerTypeDataSource,
            category: categoryDataSource,
            product: productDataSource
        )
    }
}

