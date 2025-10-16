//
//  CustomerTypeRepository.swift
//  fly-shop
//
//  Created by Olga Covaliova on 14.10.2025.
//

import Foundation

protocol CustomerTypeRepository {
    func getCustomerTypes() async -> Result<[CustomerType], DomainError>
}
