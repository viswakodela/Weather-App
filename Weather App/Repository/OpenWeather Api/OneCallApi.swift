//
//  OpenWeatherApi.swift
//  Weather App
//
//  Created by Viswa Kodela on 2/21/21.
//

import Foundation
import WeatherNetworking

public class OpenWeatherMapAPIClient {
    private var apiKey: String
    var baseURL = URL(string: "https://api.openweathermap.org/data/2.5")!
    
    public init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    public convenience init() {
        guard let infoPlistAPIKey = Bundle.main.infoDictionary?["OpenWeatherMapApiKey"] as? String else {
            fatalError("You must supply API key either in the initializer or in the Info.plist under `OpenWeatherMapApiKey`")
        }
        self.init(apiKey: infoPlistAPIKey)
    }
}

enum OneCallApi {
    private static let OWClient = OpenWeatherMapAPIClient()
    
    case oneCallApi(path: String, parameters: Parameters)
}

extension OneCallApi: EndPointType {
    var baseURL: URL {
        return OneCallApi.OWClient.baseURL
    }
    
    var path: String {
        switch self {
        case .oneCallApi(let path, _):
            return path
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        case .oneCallApi(_, let parameters):
            return .requestParameters(urlParameters: parameters)
        }
    }
    
    var headers: HTTPHeaders? {
        return HTTPHeaders()
    }
}
