//
//  NetworkError.swift
//  WeatherNetworking
//
//  Created by Viswa Kodela on 2/21/21.
//

import Foundation

enum NetworkError: Error {
    case badUrl
    case unknown
}


struct WeatherAppError<E: Error>: Error {
    let error: E
}
