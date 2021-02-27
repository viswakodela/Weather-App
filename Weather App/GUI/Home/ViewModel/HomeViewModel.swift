//
//  HomeViewModel.swift
//  Weather App
//
//  Created by Viswa Kodela on 2/21/21.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    // MARK:- Properties
    @Published
    var isPresented: Bool = false
    
    var cancellables = Set<AnyCancellable>()
    
    var addButtonSubject = CurrentValueSubject<Bool, Never>(false)
    
    private var canPresentAddCity: AnyPublisher<Bool, Never> {
        addButtonSubject
            .eraseToAnyPublisher()
    }
    
    var chosenCity: City?
    
    // MARK:- init
    init() {
        canPresentAddCity
            .assign(to: \.isPresented, on: self)
            .store(in: &cancellables)
    }
    
    // MARK:- Helper Methods
    func addButtonAction() {
        addButtonSubject.send(true)
    }
    
    func chosenCity(from cityView: AddCityView) {
        cityView
            .cityViewController
            .$selectedCity
            .dropFirst()
            .assign(to: \.chosenCity, on: self)
            .store(in: &cancellables)
    }
}
