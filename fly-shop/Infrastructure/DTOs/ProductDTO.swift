//
//  Product.swift
//  fly-shop
//
//  Created by Olga Covaliova on 13.10.2025.
//

import Foundation

struct ProductDTO: Codable {
    let name: String
    let imageURL: String
    let category: Category
    
    init(
        name: String,
        imageName: String,
        category: Category,
    ) {
        self.name = name
        self.imageURL = imageName
        self.category = category
    }
}
