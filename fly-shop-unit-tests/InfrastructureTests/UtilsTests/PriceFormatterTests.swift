//
//  PriceFormatterTests.swift
//  FlyShopUnitTests
//
//  Created by Olga Covaliova on 20.10.2025.
//

import Testing
import Foundation
@testable import fly_shop

struct PriceFormatterTests {
    
    // Use a consistent locale for all tests to ensure predictable results
    private let testLocale = Locale(identifier: "en_US")
    
    @Test("formatPrice should format USD price with correct symbol")
    func testFormatPriceUSD() {
        let price: Decimal = 1234.56
        let result = PriceFormatter.formatPrice(price: price, currency: .usd, locale: testLocale)
        
        #expect(result != nil)
        #expect(result == "$1,234.56") 
    }
    
    @Test("formatPrice should format EUR and GBP with correct symbols")
    func testFormatPriceOtherCurrencies() {
        let price: Decimal = 100.00
        
        let eurResult = PriceFormatter.formatPrice(price: price, currency: .eur, locale: testLocale)
        let gbpResult = PriceFormatter.formatPrice(price: price, currency: .gbp, locale: testLocale)
        
        #expect(eurResult == "€100.00")
        #expect(gbpResult == "£100.00")
    }
    
    @Test("formatPrice should use USD as default currency")
    func testFormatPriceDefaultCurrency() {
        let price: Decimal = 100.00
        let result = PriceFormatter.formatPrice(price: price, locale: testLocale)
        
        #expect(result == "$100.00")
    }
    
    @Test("formatPaymentComponents should return correct amount and currency")
    func testFormatPaymentComponents() {
        let price: Decimal = 1234.56
        let result = PriceFormatter.formatPaymentComponents(price: price, currency: .usd, locale: testLocale)
        
        #expect(result.amount == "1,234.56")
        #expect(result.currency == "USD")
    }
    
    @Test("formatPaymentComponents should handle zero price")
    func testFormatPaymentComponentsZero() {
        let price: Decimal = 0.00
        let result = PriceFormatter.formatPaymentComponents(price: price, currency: .usd, locale: testLocale)
        
        #expect(result.amount == "0.00")
        #expect(result.currency == "USD")
    }
    
    @Test("formatPrice should respect fraction digits constraints")
    func testFormatPriceFractionDigits() {
        let price: Decimal = 100.123456
        let result = PriceFormatter.formatPrice(price: price, currency: .usd, locale: testLocale)
        
        // Should be rounded to 2 decimal places
        #expect(result == "$100.12")
    }
}
