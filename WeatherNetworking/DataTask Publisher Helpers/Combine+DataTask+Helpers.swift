//
//  Combine+DataTask+Helpers.swift
//  WeatherNetworking
//
//  Created by Viswa Kodela on 2/21/21.
//

import Combine

public extension Publisher where Output == (data: Data, response: URLResponse) {
    func assumeHTTP() -> AnyPublisher<(data: Data, response: HTTPURLResponse), OpenWeatherNetworkError> {
        tryMap { (data: Data, response: URLResponse) in
            guard let http = response as? HTTPURLResponse else { throw OpenWeatherNetworkError.nonHTTPResponse }
            return (data, http)
        }
        .mapError { error in
            if error is OpenWeatherNetworkError {
                return error as! OpenWeatherNetworkError
            } else {
                return OpenWeatherNetworkError.networkError(error)
            }
        }
        .eraseToAnyPublisher()
    }
}

public extension Publisher where Output == (data: Data, response: HTTPURLResponse),
                                 Failure == OpenWeatherNetworkError {
    
    func responseData() -> AnyPublisher<(data: Data, response: HTTPURLResponse), OpenWeatherNetworkError> {
        tryMap { (data: Data, response: HTTPURLResponse) in
            switch response.statusCode {
            case 200...299: return (data, response)
            case 400...499: throw OpenWeatherNetworkError.requestFailed(response.statusCode)
            case 500...599: throw OpenWeatherNetworkError.serverError(response.statusCode)
            default:
                throw OpenWeatherNetworkError.unhandledResponse("Unhandled HTTP Response Status code: \(response.statusCode)")
            }
        }
        .mapError({ $0 as! OpenWeatherNetworkError })
        .eraseToAnyPublisher()
    }
}
