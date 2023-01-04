//
//  CLLocationCoordinate2D+distanceInMeters.swift
//  ThingsInAMap
//
//  Created by Ian Magallan on 01.01.23.
//

import CoreLocation
import Foundation

extension CLLocationCoordinate2D {
    func distanceInMeters(to p2: CLLocationCoordinate2D) -> Double {
        let p1Location = CLLocation(latitude: latitude, longitude: longitude)
        let p2Location = CLLocation(latitude: p2.latitude, longitude: p2.longitude)
        return p1Location.distance(from: p2Location)
    }
}
