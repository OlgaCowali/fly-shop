//
//  CardholderName.swift
//  fly-shop
//
//  Created by Olga Covaliova on 24.10.2025.
//

import Foundation

// Value object representing a valid cardholder name
struct CardholderName: Equatable {
    let value: String
    
    // Creates a CardholderName from a raw string value
    init?(_ rawValue: String) {
        let trimmed = rawValue.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Name should not be empty and should contain only letters and spaces
        guard !trimmed.isEmpty,
              trimmed.allSatisfy({ $0.isLetter || $0.isWhitespace }) else {
            return nil
        }
        
        self.value = trimmed
    }
}

