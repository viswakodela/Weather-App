//
//  AddLocationViewModel.swift
//  Weather App
//
//  Created by Viswa Kodela on 2/21/21.
//

import Foundation
import Combine
import WeatherNetworking
import MapKit

class AddLocationViewModel: NSObject, ObservableObject {
    // MARK:- Properties
    private let apiKey: String
    // Api
    private let manager = OpenWeatherApiManager()
    var searchText: String? {
        didSet {
            searchCompleter.queryFragment = searchText ?? ""
        }
    }
    enum Errors: Error {
        case geolocationFailed
    }
    
    // Map
    private var searchCompleter = MKLocalSearchCompleter()
    private var geocoder = CLGeocoder()
    
    // Combine
    private var completionSubject = CurrentValueSubject<[MKLocalSearchCompletion], Never>([])
    private var cancellables = Set<AnyCancellable>()
    
    @Published
    var results = [AddCityViewController.Result]()
    
    var snapshotPublisher: AnyPublisher<NSDiffableDataSourceSnapshot<AddCityViewController.Section, AddCityViewController.Result>, Never> {
        $results
            .map { results in
                var snapshot = NSDiffableDataSourceSnapshot<AddCityViewController.Section, AddCityViewController.Result>()
                snapshot.appendSections([.results])
                snapshot.appendItems(results)
                return snapshot
            }
            .eraseToAnyPublisher()
    }
    
    override init() {
        guard let infoPlistAPIKey = Bundle.main.infoDictionary?["OpenWeatherMapApiKey"] as? String else {
            fatalError("You must supply API key either in the initializer or in the Info.plist under `OpenWeatherMapApiKey`")
        }
        //manager.fetchOneCallApi(lat: 42.983612, lon: -81.249725, apiKey: infoPlistAPIKey)
        self.apiKey = infoPlistAPIKey
        super.init()
        searchCompleter.delegate = self
        
        completionSubject
            .debounce(for: 0.4, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { completions in
                completions
                    .filter { $0.title.contains(",") }
                    .map { AddCityViewController.Result(title: $0.title, subtitle: $0.subtitle) }
            }
            .assign(to: &$results)
    }
    
    func geolocate(selectedIndex index: Int) -> AnyPublisher<City, Error>  {
        geocoder.cancelGeocode()
        let result = results[index]
        return Future { [self] promise in
            self.geocoder.geocodeAddressString(result.title) { (placemarks, error) in
                if let placemark = placemarks?.first {
                    promise(.success(placemark))
                } else {
                    promise(.failure(Errors.geolocationFailed))
                }
            }
        }
        .map { (placemark: CLPlacemark) -> City in
            City(
                name: placemark.name ?? placemark.locality ?? "(unknown city)",
                locality: placemark.administrativeArea ?? placemark.country ?? "",
                latitude: placemark.location?.coordinate.latitude ?? 0,
                longitude: placemark.location?.coordinate.longitude ?? 0
            )
        }
        .eraseToAnyPublisher()
    }
}

extension AddLocationViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        completionSubject.send(completer.results)
    }
}
