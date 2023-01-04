//
//  Geocoder.swift
//  ThingsInAMap
//
//  Created by Ian Magallan on 02.01.23.
//

import CoreLocation

protocol Geocoding {
    func reverseGeocodeLocation(_ location: CLLocation) async throws -> Placemark
}

final class Geocoder: Geocoding {
    private let geocoder = CLGeocoder()

    func reverseGeocodeLocation(_ location: CLLocation) async throws -> Placemark {
        let clPlacemark = try await geocoder.reverseGeocodeLocation(location)
        return .init(street: clPlacemark.first?.thoroughfare, number: clPlacemark.first?.subThoroughfare)
    }
}

struct Placemark {
    let street: String?
    let number: String?
}
