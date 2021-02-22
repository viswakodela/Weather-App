//
//  ParameterEncoder.swift
//  WeatherNetworking
//
//  Created by Viswa Kodela on 2/21/21.
//

import Foundation


/// **ParameterEncoder** is a protocol that helps the receiver to encode the *httpBody* and/or *URLQueryParamters*.
public protocol ParameterEncoder {
    /// This method that gets called when you conform to **ParameterEncoder** protocol.
    /// - Parameters:
    ///   - urlRequest: request that is sent from the NetworkRouter after building the URLRequest. we are using `inout` because it helps us modify the request and pass it accordingly.
    ///   - parameters: `Parameters` that will be added to the `URLRequest` if they are not empty.
    ///   - httpBody: `HTTPBody` that will be added to the `URLRequest` if there are any parameters available.
    ///   In this application we are only using httpBody to send the `SPC Data` to the `Key Service` when requesting the `Fairplay` services.
    static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}

/// **URLParameterEncoder** is used only to add the *URLQueryItems* to the *URLRequest*
public struct URLParameterEncoder: ParameterEncoder {
    public static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        guard let url = urlRequest.url else { throw OpenWeatherNetworkError.nonHTTPResponse }

        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            urlComponents.queryItems = [URLQueryItem]()

            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
                urlComponents.queryItems?.append(queryItem)
            }
            urlRequest.url = urlComponents.url
        }

        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
    }
}
