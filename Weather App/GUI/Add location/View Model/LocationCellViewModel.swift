//
//  LocationCellViewModel.swift
//  Weather App
//
//  Created by Viswa Kodela on 2021-02-26.
//

import UIKit

class LocationCellViewModel: TableViewCellModelProtocol {
    
    // MARK:- Computed Properties
    var identifier: String {
        return String(describing: LocationCellViewModel.self)
    }
    
    // MARK:- Properties
    let title: String
    let subtitle: String
    
    // MARK:- init
    init(title: String, subtitle: String) {
        self.title = title
        self.subtitle = subtitle
    }
}

extension LocationCellViewModel: Equatable, Hashable {
    static func == (lhs: LocationCellViewModel, rhs: LocationCellViewModel) -> Bool {
        lhs.identifier == rhs.identifier
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}
