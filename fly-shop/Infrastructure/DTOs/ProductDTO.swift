//
//  ProductDTO.swift
//  fly-shop
//
//  Created by Olga Covaliova on 13.10.2025.
//

import Foundation

struct ProductDTO: Codable {
    let name: String
    let imageURL: String
    let category: CategoryDTO
    let prices: [String: Decimal]
    
    init(
        name: String,
        imageName: String,
        category: CategoryDTO,
        prices: [String: Decimal]
    ) {
        self.name = name
        self.imageURL = imageName
        self.category = category
        self.prices = prices
    }
}
