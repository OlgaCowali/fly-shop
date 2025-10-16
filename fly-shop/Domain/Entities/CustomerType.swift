//
//  CustomerType.swift
//  fly-shop
//
//  Created by Olga Covaliova on 13.10.2025.
//

import Foundation

struct CustomerType: Codable, Identifiable, Hashable {
    let key: String
    let name: String
    let isDefault: Bool
    
    var id: String { key }
    
    init(key: String, name: String, isDefault: Bool = false) {
        self.key = key
        self.name = name
        self.isDefault = isDefault
    }
}

