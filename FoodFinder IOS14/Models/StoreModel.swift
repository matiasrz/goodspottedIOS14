//
//  StoreModel.swift
//  FoodFinder IOS14
//
//  Created by Matias Rojas Zuñiga on 12/11/2020.
//

import Foundation
import CoreLocation

struct StoreModel {
//    Stored properties
    let name: String
    let country: String
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees

//    Computed Properties
    var location: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
