//
//  CompositionRootTests.swift
//  FlyShopUnitTests
//
//  Created by Olga Covaliova on 17.10.2025.
//

import Testing
import SwiftUI
@testable import fly_shop

struct CompositionRootTests {
    
    @Test("Should return different instances on multiple calls")
    @MainActor func testInstanceCreation() async {
        let compositionRoot = CompositionRoot()
        let viewModel1 = compositionRoot.makeProductListViewModel()
        let viewModel2 = compositionRoot.makeProductListViewModel()
        
        // Should return different instances (not singleton)
        #expect(viewModel1 !== viewModel2)
    }
    
    @Test("Should create view model without throwing")
    @MainActor func testMakeProductListViewModelDoesNotThrow() async {
        let compositionRoot = CompositionRoot()
        
        // Test that the method doesn't throw an exception
        #expect(throws: Never.self) {
            let _ = compositionRoot.makeProductListViewModel()
        }
    }
}
