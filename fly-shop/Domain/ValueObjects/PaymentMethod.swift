//
//  PaymentMethod.swift
//  fly-shop
//
//  Created by Olga Covaliova on 13.10.2025.
//

import Foundation

enum PaymentMethod: String, Codable, CaseIterable, Identifiable {
    case cash = "cash"
    case card = "card"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .cash:
            return "Cash"
        case .card:
            return "Card"
        }
    }
}

