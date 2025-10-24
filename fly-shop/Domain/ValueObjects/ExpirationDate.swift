//
//  ExpirationDate.swift
//  fly-shop
//
//  Created by Olga Covaliova on 24.10.2025.
//

import Foundation

// Value object representing a valid card expiration date
struct ExpirationDate: Equatable {
    let value: String
    let month: Int
    let year: Int
    
    // Creates an ExpirationDate from a raw string value in MM/YY format
    init?(_ rawValue: String) {
        // Check format MM/YY
        guard rawValue.count == 5,
              rawValue.contains("/"),
              let month = Int(rawValue.prefix(2)),
              let year = Int(rawValue.suffix(2)) else {
            return nil
        }
        
        // Check month range (1-12)
        guard month >= 1 && month <= 12 else {
            return nil
        }
        
        // Check if date is in the future
        let currentDate = Date()
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: currentDate) % 100
        let currentMonth = calendar.component(.month, from: currentDate)
        
        // Card is expired if year is past, or year is current but month is past
        if year < currentYear || (year == currentYear && month < currentMonth) {
            return nil
        }
        
        self.value = rawValue
        self.month = month
        self.year = year
    }
    
    // Checks if the expiration date is still valid (not expired)
    func isValid() -> Bool {
        let currentDate = Date()
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: currentDate) % 100
        let currentMonth = calendar.component(.month, from: currentDate)
        
        return year > currentYear || (year == currentYear && month >= currentMonth)
    }
}

