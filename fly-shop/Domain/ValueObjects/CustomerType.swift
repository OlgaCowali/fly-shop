//
//  PriceType.swift
//  fly-shop
//
//  Created by Olga Covaliova on 13.10.2025.
//

import Foundation

enum CustomerType: String, Codable, CaseIterable, Identifiable {
    case retail = "retail"
    case crew = "crew"
    case happyHour = "happy_hour"
    case businessInvitation = "business_invitation"
    case touristInvitation = "tourist_invitation"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .retail:
            return "Retail"
        case .crew:
            return "Crew"
        case .happyHour:
            return "Happy Hour"
        case .businessInvitation:
            return "Business Invitation"
        case .touristInvitation:
            return "Tourist Invitation"
        }
    }
}

