//
//  OneCallDecodable.swift
//  Weather App
//
//  Created by Viswa Kodela on 2/21/21.
//

import Foundation

struct OneCallDecodable: Decodable {
    let lat: Double
    let lon: Double
}

public struct City: Codable {
    public let name: String
    public let locality: String
    public let latitude: Double
    public let longitude: Double
    
    public init(name: String, locality: String, latitude: Double, longitude: Double) {
        self.name = name
        self.locality = locality
        self.latitude = latitude
        self.longitude = longitude
    }
}

extension City: Equatable, Hashable {
}
