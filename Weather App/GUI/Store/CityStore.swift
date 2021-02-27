//
//  CityStore.swift
//  Weather App
//
//  Created by Viswa Kodela on 2021-02-26.
//

import Foundation
import Combine

protocol Store {
    associatedtype T
    func add(item: T)
    func delete(item: T)
    func save() throws
}

class CityStore: Store {
    
    // MARK:- Properties
    @Published
    var cities = [City]()
    
    enum UDCitiesKey: String {
        case citesStore
    }
    
    // MARK:- init
    init(cities: [City]) {
        self.cities = cities
    }
    
    // MARK:- Helpers
    func add(item: City) {
        cities.append(item)
        try! save()
    }
    
    func delete(item: City) {
        guard let index = cities.firstIndex(where: { $0 == item } ) else { return }
        cities.remove(at: index)
        try! save()
    }
    
    internal func save() throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(cities)
        UserDefaults.standard.set(data, forKey: UDCitiesKey.citesStore.rawValue)
    }
    
    static func load() -> CityStore {
        let decoder = JSONDecoder()
        guard let data = UserDefaults.standard.data(forKey: UDCitiesKey.citesStore.rawValue) else {
            return CityStore(cities: [])
        }
        
        do {
            let cities = try decoder.decode([City].self, from: data)
            return CityStore(cities: cities)
        } catch {
            print("Error fetching cities from UserDefaults: \(error)")
            return CityStore(cities: [])
        }
    }
}
