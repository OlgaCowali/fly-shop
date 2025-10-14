//
//  Category.swift
//  fly-shop
//
//  Created by Olga Covaliova on 13.10.2025.
//

import Foundation

enum Category: String, Identifiable, Codable, Hashable, CaseIterable {
    case beverages = "Beverages"
    case snacks = "Snacks"
    case meals = "Meals"
    case dutyFree = "Duty-Free"
    case electronics = "Electronics"
    
    var id: String {
        rawValue
    }
    
    var name: String {
        rawValue
    }
    
    static var allCategories: [Category] {
        Category.allCases
    }
}

