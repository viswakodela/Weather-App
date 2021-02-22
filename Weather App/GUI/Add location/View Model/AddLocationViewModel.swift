//
//  AddLocationViewModel.swift
//  Weather App
//
//  Created by Viswa Kodela on 2/21/21.
//

import Foundation
import Combine
import WeatherNetworking

class AddLocationViewModel: ObservableObject {
    private let manager = OpenWeatherApiManager()
    init() {
        guard let infoPlistAPIKey = Bundle.main.infoDictionary?["OpenWeatherMapApiKey"] as? String else {
            fatalError("You must supply API key either in the initializer or in the Info.plist under `OpenWeatherMapApiKey`")
        }
        manager.fetchOneCallApi(lat: 42.983612, lon: -81.249725, apiKey: infoPlistAPIKey)
    }
}
