//
//  Currency.swift
//  fly-shop
//
//  Created by Olga Covaliova on 13.10.2025.
//

import Foundation

enum Currency: String, Identifiable, Hashable, Codable {
    case usd = "USD"
    case eur = "EUR"
    case gbp = "GBP"
    
    var id: String {
        rawValue
    }
    
    var name: String {
        rawValue
    }
    
    var symbol: String {
        switch self {
        case .usd: return "$"
        case .eur: return "€"
        case .gbp: return "£"
        }
    }
    
    static let all: [Currency] = [.usd, .eur, .gbp]
}

