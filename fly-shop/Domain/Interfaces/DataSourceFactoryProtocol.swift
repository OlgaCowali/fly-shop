//
//  DataSourceFactoryProtocol.swift
//  fly-shop
//
//  Created by Olga Covaliova on 18.10.2025.
//

import Foundation

// Protocol defining the interface for data source factory
protocol DataSourceFactoryProtocol {
    func makePaymentDataSource() -> APIPaymentDataSource
}
