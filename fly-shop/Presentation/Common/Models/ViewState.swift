//
//  ViewState.swift
//  fly-shop
//
//  Created by Olga Covaliova on 23.10.2025.
//

enum ViewState: Equatable {
    case loading
    case loaded
    case empty
    case error(DomainError)
}
