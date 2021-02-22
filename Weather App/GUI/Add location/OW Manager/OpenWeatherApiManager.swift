//
//  OpenWeatherApiManager.swift
//  Weather App
//
//  Created by Viswa Kodela on 2/21/21.
//

import Foundation
import WeatherNetworking
import Combine

class OpenWeatherApiManager {
    private let weatherApi = NetworkManager<OneCallApi>()
    private var cancellables = Set<AnyCancellable>()
    
    func fetchOneCallApi(lat: Double, lon: Double, apiKey: String) {
        let params: Parameters = ["lat" : lat,
                                  "lon" : lon,
                                  "appid" : apiKey,]
        
        
        weatherApi
            .request(.oneCallApi(path: "onecall", parameters: params), result: OneCallDecodable.self)
            .map { $0 }
            .sink { (completion) in
                print(completion)
            } receiveValue: { value in
                print(value)
            }
            .store(in: &cancellables)
    }
}
