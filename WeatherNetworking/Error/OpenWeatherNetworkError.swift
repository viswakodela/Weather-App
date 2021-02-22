//
//  OpenWeatherNetworkError.swift
//  WeatherNetworking
//
//  Created by Viswa Kodela on 2/21/21.
//

import Foundation

public enum OpenWeatherNetworkError: Error {
    case nonHTTPResponse
    case requestFailed(Int)
    case serverError(Int)
    case networkError(Error)
    case decodingError(DecodingError)
    case unhandledResponse(String)
    
    public var isRetriable: Bool {
        switch self {
        case .decodingError, .unhandledResponse:
            return false
            
        case .requestFailed(let status):
            let timeoutStatus = 408
            let rateLimitStatus = 429
            return [timeoutStatus, rateLimitStatus].contains(status)
            
        case .serverError, .networkError, .nonHTTPResponse:
            return true
        }
    }
}


struct WeatherAppError<E: Error>: Error {
    let error: E
}
