//
//  CardFormatterTests.swift
//  fly-shop
//
//  Created by Olga Covaliova on 24.10.2025.
//

import Testing
@testable import fly_shop

struct CardFormatterTests {
    
    // MARK: - formatCardNumber Tests
    
    @Test("Format card number with spaces")
    func formatCardNumberWithSpaces() {
        let input = "1234567890123456"
        let result = CardFormatter.formatCardNumber(input)
        #expect(result == "1234 5678 9012 3456")
    }
    
    @Test("Format card number with existing spaces")
    func formatCardNumberWithExistingSpaces() {
        let input = "1234 5678 9012 3456"
        let result = CardFormatter.formatCardNumber(input)
        #expect(result == "1234 5678 9012 3456")
    }
    
    @Test("Format card number with extra spaces")
    func formatCardNumberWithExtraSpaces() {
        let input = "1234  5678  9012  3456"
        let result = CardFormatter.formatCardNumber(input)
        #expect(result == "1234 5678 9012 3456")
    }
    
    @Test("Format card number longer than 16 digits")
    func formatCardNumberTooLong() {
        let input = "12345678901234567890"
        let result = CardFormatter.formatCardNumber(input)
        #expect(result == "1234 5678 9012 3456")
    }
    
    @Test("Format card number shorter than 16 digits")
    func formatCardNumberShort() {
        let input = "1234567890"
        let result = CardFormatter.formatCardNumber(input)
        #expect(result == "1234 5678 90")
    }
    
    @Test("Format empty card number")
    func formatCardNumberEmpty() {
        let input = ""
        let result = CardFormatter.formatCardNumber(input)
        #expect(result == "")
    }
    
    // MARK: - formatExpirationDate Tests
    
    @Test("Format expiration date MM/YY")
    func formatExpirationDateValid() {
        let input = "1225"
        let result = CardFormatter.formatExpirationDate(input)
        #expect(result == "12/25")
    }
    
    @Test("Format expiration date with existing slash")
    func formatExpirationDateWithSlash() {
        let input = "12/25"
        let result = CardFormatter.formatExpirationDate(input)
        #expect(result == "12/25")
    }
    
    @Test("Format expiration date with extra slashes")
    func formatExpirationDateWithExtraSlashes() {
        let input = "12//25"
        let result = CardFormatter.formatExpirationDate(input)
        #expect(result == "12/25")
    }
    
    @Test("Format expiration date longer than 4 digits")
    func formatExpirationDateTooLong() {
        let input = "122567"
        let result = CardFormatter.formatExpirationDate(input)
        #expect(result == "12/25")
    }
    
    @Test("Format expiration date shorter than 2 digits")
    func formatExpirationDateShort() {
        let input = "1"
        let result = CardFormatter.formatExpirationDate(input)
        #expect(result == "1")
    }
    
    @Test("Format expiration date exactly 2 digits")
    func formatExpirationDateTwoDigits() {
        let input = "12"
        let result = CardFormatter.formatExpirationDate(input)
        #expect(result == "12/")
    }
    
    @Test("Format empty expiration date")
    func formatExpirationDateEmpty() {
        let input = ""
        let result = CardFormatter.formatExpirationDate(input)
        #expect(result == "")
    }
    
    // MARK: - formatCVV Tests
    
    @Test("Format CVV with 3 digits")
    func formatCVVThreeDigits() {
        let input = "123"
        let result = CardFormatter.formatCVV(input)
        #expect(result == "123")
    }
    
    @Test("Format CVV with 4 digits")
    func formatCVVFourDigits() {
        let input = "1234"
        let result = CardFormatter.formatCVV(input)
        #expect(result == "1234")
    }
    
    @Test("Format CVV with letters and numbers")
    func formatCVVWithLetters() {
        let input = "12a3b"
        let result = CardFormatter.formatCVV(input)
        #expect(result == "123")
    }
    
    @Test("Format CVV longer than 4 digits")
    func formatCVVTooLong() {
        let input = "123456"
        let result = CardFormatter.formatCVV(input)
        #expect(result == "1234")
    }
    
    @Test("Format CVV with special characters")
    func formatCVVWithSpecialChars() {
        let input = "12-3@4"
        let result = CardFormatter.formatCVV(input)
        #expect(result == "1234")
    }
    
    @Test("Format empty CVV")
    func formatCVVEmpty() {
        let input = ""
        let result = CardFormatter.formatCVV(input)
        #expect(result == "")
    }
    
    // MARK: - formatCardholderName Tests
    
    @Test("Format cardholder name with letters only")
    func formatCardholderNameLettersOnly() {
        let input = "JohnDoe"
        let result = CardFormatter.formatCardholderName(input)
        #expect(result == "JohnDoe")
    }
    
    @Test("Format cardholder name with spaces")
    func formatCardholderNameWithSpaces() {
        let input = "John Doe"
        let result = CardFormatter.formatCardholderName(input)
        #expect(result == "John Doe")
    }
    
    @Test("Format cardholder name with numbers")
    func formatCardholderNameWithNumbers() {
        let input = "John123Doe"
        let result = CardFormatter.formatCardholderName(input)
        #expect(result == "JohnDoe")
    }
    
    @Test("Format cardholder name with special characters")
    func formatCardholderNameWithSpecialChars() {
        let input = "John-Doe@Smith"
        let result = CardFormatter.formatCardholderName(input)
        #expect(result == "JohnDoeSmith")
    }
    
    @Test("Format cardholder name with multiple spaces")
    func formatCardholderNameMultipleSpaces() {
        let input = "John  Doe   Smith"
        let result = CardFormatter.formatCardholderName(input)
        #expect(result == "John  Doe   Smith")
    }
    
    @Test("Format empty cardholder name")
    func formatCardholderNameEmpty() {
        let input = ""
        let result = CardFormatter.formatCardholderName(input)
        #expect(result == "")
    }
}

