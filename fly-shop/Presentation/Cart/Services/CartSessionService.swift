//
//  CartSessionService.swift
//  fly-shop
//
//  Created by Olga Covaliova on 24.10.2025.
//

import Foundation
import SwiftUI
import Combine

// Protocol defining cart session management operations
@MainActor
protocol CartSessionService: AnyObject {
    var selectedProducts: [Product] { get }
    var selectedProductsPublisher: AnyPublisher<[Product], Never> { get }
    var selectedSeat: String { get set }
    
    func addProduct(_ product: Product)
    func removeProduct(productId: UUID)
    func updateProductQuantity(_ productId: UUID, quantity: Int)
    func updateSeat(_ seat: String)
}
