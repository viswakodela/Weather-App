//
//  RequestManager.swift
//  WeatherNetworking
//
//  Created by Viswa Kodela on 2/21/21.
//

import Foundation
import Combine

/// **NetworkRouter** is responsible to create the router by using the attributes specified in the requested *Endpoint*
protocol NetworkRequest: AnyObject {
    associatedtype Endpoint: EndPointType
    func request<D: Decodable>(_ route: Endpoint, result: D.Type) -> AnyPublisher<D, NetworkError>
    func cancel()
}


public class NetworkManager<Endpoint: EndPointType>: NetworkRequest {
    
    public init() {}
    
    public func request<D>(_ route: Endpoint, result: D.Type) -> AnyPublisher<D, NetworkError> where D : Decodable {
        let session = URLSession.shared
        
        do {
            let request = try buildRequest(from: route)
            return session.dataTaskPublisher(for: request)
                .tryMap { (data: Data, response: URLResponse) in
                    guard let http = response as? HTTPURLResponse else { throw NetworkError.nonHTTPResponse }
                    return (data, http)
                }
                .mapError { error -> Error in
                    if error is NetworkError {
                        return error as! NetworkError
                    } else {
                        return NetworkError.networkError(error)
                    }
                }
                .tryMap { (data: Data, response: HTTPURLResponse) -> Data in
                    switch response.statusCode {
                    case 200...299: return data
                    case 400...499: throw NetworkError.requestFailed(response.statusCode)
                    case 500...599: throw NetworkError.serverError(response.statusCode)
                    default:
                        throw NetworkError.unhandledResponse("Unhandled HTTP Response Status code: \(response.statusCode)")
                    }
                }
                .mapError({ $0 as! NetworkError })
                .decode(type: D.self, decoder: JSONDecoder())
                .mapError { error in
                    if error is DecodingError {
                        return NetworkError.decodingError(error as! DecodingError)
                    } else {
                        return error as! NetworkError
                    }
                }
                .eraseToAnyPublisher()
        } catch {
            let error = NetworkError.networkError(error)
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }
    
    func cancel() {}
    
    /// Helps build the route for the given *Endpoint*
    /// - Parameter route: ...
    private func buildRequest(from route: Endpoint) throws -> URLRequest {
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path), cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 60)
        request.httpMethod = route.httpMethod.rawValue
        
        do {
            // swiftlint:disable pattern_matching_keywords
            switch route.task {
            case .requestParameters(let bodyParameters, let urlParameters):
                try self.configureParameters(bodyParameters: bodyParameters, urlParameters: urlParameters, request: &request)
                
            case .requestParametersAndHeaders(let bodyParameters, let urlParameters, let additionalHeaders):
                self.addAdditionalHeaders(additionalHeaders, request: &request)
                try self.configureParameters(bodyParameters: bodyParameters, urlParameters: urlParameters, request: &request)
            }
            return request
        } catch {
            throw error
        }
    }
    
    /// Adds the parameters to the *URLRequest* if they are non nil
    /// - Parameters:
    ///   - bodyParameters: bodyParameters defaulted with `nil`
    ///   - urlParameters: urlParameters defaulted with `nil`
    ///   - httpBody: httpBody defaulted with `nil`
    ///   - request: *URLRequest*
    private func configureParameters(bodyParameters: Parameters? = nil, urlParameters: Parameters? = nil, request: inout URLRequest) throws {
        do {
            if let bodyParameters = bodyParameters {
                try JSONParameterEncoder.encode(urlRequest: &request, with: bodyParameters)
            }
            
            if let urlParameters = urlParameters {
                try URLParameterEncoder.encode(urlRequest: &request, with: urlParameters)
            }
        }
    }
    
    /// Adds headers to the *URLRequest*
    /// - Parameters:
    ///   - additionalHeaders: headers that will be added.
    ///   - request: *URLRequest*
    private func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}
