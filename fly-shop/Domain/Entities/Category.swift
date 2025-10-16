//
//  Category.swift
//  fly-shop
//
//  Created by Olga Covaliova on 13.10.2025.
//

import Foundation

struct Category: Codable, Identifiable, Hashable {
    let name: String
    let key: String
    
    var id: String { name }
    
    init(name: String, key: String) {
        self.name = name
        self.key = key
    }
}

