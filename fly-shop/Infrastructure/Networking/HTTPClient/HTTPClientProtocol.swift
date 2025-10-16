//
//  HTTPClientProtocol.swift
//  fly-shop
//
//  Created by Olga Covaliova on 16.10.2025.
//
import Foundation

protocol HTTPClientProtocol {
    func makeRequest(endpoint: Endpoint) async -> Result<Data, HTTPClientError>
}
