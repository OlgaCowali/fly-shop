//
//  CVV.swift
//  fly-shop
//
//  Created by Olga Covaliova on 24.10.2025.
//

import Foundation

// Value object representing a valid CVV security code
struct CVV: Equatable {
    let value: String
    
    // Creates a CVV from a raw string value
    init?(_ rawValue: String) {
        // CVV should be 3-4 digits
        guard rawValue.count >= 3 && rawValue.count <= 4,
              rawValue.allSatisfy({ $0.isNumber }) else {
            return nil
        }
        
        self.value = rawValue
    }
}

