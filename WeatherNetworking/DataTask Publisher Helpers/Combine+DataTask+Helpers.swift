//
//  Combine+DataTask+Helpers.swift
//  WeatherNetworking
//
//  Created by Viswa Kodela on 2/21/21.
//

import Combine

public extension Publisher where Output == (data: Data, response: URLResponse) {
    func assumeHTTP() -> AnyPublisher<(data: Data, response: HTTPURLResponse), NetworkError> {
        tryMap { (data: Data, response: URLResponse) in
            guard let http = response as? HTTPURLResponse else { throw NetworkError.nonHTTPResponse }
            return (data, http)
        }
        .mapError { error in
            if error is NetworkError {
                return error as! NetworkError
            } else {
                return NetworkError.networkError(error)
            }
        }
        .eraseToAnyPublisher()
    }
}

public extension Publisher where Output == (data: Data, response: HTTPURLResponse),
                                 Failure == NetworkError {
    
    func responseData() -> AnyPublisher<(data: Data, response: HTTPURLResponse), NetworkError> {
        tryMap { (data: Data, response: HTTPURLResponse) in
            switch response.statusCode {
            case 200...299: return (data, response)
            case 400...499: throw NetworkError.requestFailed(response.statusCode)
            case 500...599: throw NetworkError.serverError(response.statusCode)
            default:
                throw NetworkError.unhandledResponse("Unhandled HTTP Response Status code: \(response.statusCode)")
            }
        }
        .mapError({ $0 as! NetworkError })
        .eraseToAnyPublisher()
    }
}
