//
//  APIPaymentDataSourceImpl.swift
//  fly-shop
//
//  Created by Olga Covaliova on 24.10.2025.
//

import Foundation

class APIPaymentDataSourceImpl: APIPaymentDataSource {
    
    private let httpClient: HTTPClientProtocol
    private let paymentURL = APIConstant.paymentGatewayURL
    
    private let successResponse = PaymentResponseDTO(
        status: "success",
        statusCode: 200
    )
    
    init(httpClient: HTTPClientProtocol = HTTPClient()) {
        self.httpClient = httpClient
    }
    
    func processPayment(request: PaymentRequestDTO) async -> Result<PaymentResponseDTO, HTTPClientError> {
        // Encode the payment request to JSON
        guard let requestData = try? JSONEncoder().encode(request) else {
            return .failure(.generic)
        }
        
        // Create endpoint with POST method and request body
        let endpoint = Endpoint(
            method: .post,
            path: paymentURL,
            body: requestData
        )
        
        let result = await httpClient.makeRequest(endpoint: endpoint)
        
        switch result {
        case .success(let data):
            // Try to decode the expected payment response format
            if let paymentResponse = try? JSONDecoder().decode(PaymentResponseDTO.self, from: data) {
                return .success(paymentResponse)
            }
            
            // If response doesn't match expected format, check if it's the echoed request data
            if let _ = try? JSONDecoder().decode(PaymentRequestDTO.self, from: data) {
                
                // Create a success response since the gateway accepted and echoed our data
                return .success(successResponse)
            }
            
            return .failure(.parsingError)
            
        case .failure(let error):
            return .failure(error)
        }
    }
}

