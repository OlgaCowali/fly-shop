//
//  DomainError.swift
//  fly-shop
//
//  Created by Olga Covaliova on 15.10.2025.
//

import Foundation

enum DomainError: Error {
    case generic
    case network
    case unauthorized
    case notFound
    case server
    case decoding
}
