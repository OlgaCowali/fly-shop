//
//  APICustomerTypeDataSource.swift
//  fly-shop
//
//  Created by Olga Covaliova on 15.10.2025.
//

protocol APICustomerTypeDataSource {
    func getCustomerTypes() async -> Result<[CustomerTypeDTO], HTTPClientError>
}
