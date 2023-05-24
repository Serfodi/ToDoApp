//
//  Location.swift
//  ToDoApp
//
//  Created by Сергей Насыбуллин on 24.05.2023.
//

import Foundation
import CoreLocation

struct Location {
    let name: String
    let coordinate: CLLocationCoordinate2D?
    
    init(name: String, coordinate: CLLocationCoordinate2D? = nil) {
        self.name = name
        self.coordinate = coordinate
    }
}

extension Location: Equatable {
    
    static func == (lhs: Location, rhs: Location) -> Bool {
        guard rhs.coordinate?.latitude == lhs.coordinate?.latitude && rhs.coordinate?.longitude == lhs.coordinate?.longitude && rhs.name == lhs.name else { return false }
        return true
    }
    
}
