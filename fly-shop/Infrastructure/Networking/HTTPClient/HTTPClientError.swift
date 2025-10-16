//
//  HTTPClientError.swift
//  fly-shop
//
//  Created by Olga Covaliova on 16.10.2025.
//

enum HTTPClientError: Error {
    case clientError
    case serverError
    case parsingError
    case generic
    case responseError
}
