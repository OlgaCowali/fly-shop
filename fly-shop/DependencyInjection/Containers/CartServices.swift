//
//  CartServices.swift
//  fly-shop
//
//  Created by Olga Covaliova on 20.10.2025.
//

import Foundation

// Container struct that holds all service dependencies for the cart feature
struct CartServices {
    let sessionService: CartSessionService
    let paymentService: CashPaymentService
}
