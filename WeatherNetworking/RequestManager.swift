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
    associatedtype DecodingObject: Decodable
    func request(_ route: Endpoint) -> AnyPublisher<DecodingObject, NetworkError>
    func cancel()
}


public class NetworkManager<Endpoint: EndPointType, DecodingObject: Decodable>: NetworkRequest {
    private var task: URLSessionTask?
    
    private var cancellable: AnyCancellable?
    
    func request(_ route: Endpoint) -> AnyPublisher<DecodingObject, NetworkError> {
        let session = URLSession.shared
        
        do {
            let request = try buildRequest(from: route)
            cancellable = session.dataTaskPublisher(for: request)
                .map({ data, _ in
                    return data
                })
                .replaceError(with: Data())
                .map({ String(data: $0, encoding: .utf8) })
                .compactMap { $0 }
                .sink {
                    print($0)
                }
        } catch {
            let error = NetworkError.unknown
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
        return Just(String() as! DecodingObject)
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }
    
    func cancel() {
        task?.cancel()
    }
    
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
