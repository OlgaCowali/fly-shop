//
//  CartStateServiceProtocol.swift
//  fly-shop
//
//  Created by Olga Covaliova on 24.10.2025.
//

import SwiftUI
import Foundation

// Protocol defining cart state management operations
@MainActor
protocol CartStateServiceProtocol: ObservableObject {
    var state: ViewState { get }
    var error: DomainError? { get }
    
    func updateState(products: [Product])
    func clearError()
}
