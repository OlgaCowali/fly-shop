//
//  CardNumber.swift
//  fly-shop
//
//  Created by Olga Covaliova on 24.10.2025.
//

import Foundation

// Value object representing a valid credit card number
struct CardNumber: Equatable {
    let value: String
    
    // Creates a CardNumber from a raw string value
    init?(_ rawValue: String) {
        // Remove spaces and validate
        let cleaned = rawValue.replacingOccurrences(of: " ", with: "")
        
        // Check length and ensure all characters are digits
        guard cleaned.count == 16, 
              cleaned.allSatisfy({ $0.isNumber }) else {
            return nil
        }
        
        self.value = cleaned
    }
    
    // Returns formatted card number with spaces (XXXX XXXX XXXX XXXX)
    var formatted: String {
        var result = ""
        for (index, character) in value.enumerated() {
            if index > 0 && index % 4 == 0 {
                result += " "
            }
            result.append(character)
        }
        return result
    }
}

