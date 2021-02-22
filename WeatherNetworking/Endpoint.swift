//
//  Endpoint.swift
//  WeatherNetworking
//
//  Created by Viswa Kodela on 2/21/21.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

public protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}

public typealias Parameters = [String: Any]
public typealias HTTPHeaders = [String: String]

/// **HTTPTask** will help to choose the required case according to the *urlParameters*, *bodyParameters* and *additionalHeaders* we specify to create the **Route**
public enum HTTPTask {
    case requestParameters(bodyParameters: Parameters? = nil, urlParameters: Parameters? = nil)

    case requestParametersAndHeaders(bodyParameters: Parameters?, urlParameters: Parameters?, additionalHeaders: HTTPHeaders?)
}
