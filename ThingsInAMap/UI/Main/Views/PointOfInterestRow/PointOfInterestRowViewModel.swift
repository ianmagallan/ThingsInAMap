//
//  PointOfInterestRowViewModel.swift
//  ThingsInAMap
//
//  Created by Ian Magallan on 01.01.23.
//

import CoreLocation
import Foundation

@MainActor
final class PointOfInterestRowViewModel: ObservableObject {
    @Published var streetLocation: String = "            " {
        didSet {
            didLoadLocation = true
        }
    }

    @Published var didLoadLocation = false

    private let geocoder: Geocoding

    init(geocoder: Geocoding = Geocoder()) {
        self.geocoder = geocoder
    }

    func fetchStreetLocation(latitude: Double, longitude: Double) async {
        let location = CLLocation(latitude: latitude, longitude: longitude)

        Task { [weak self] in
            do {
                let placemark = try await geocoder.reverseGeocodeLocation(location)
                guard let street = placemark.street,
                      let number = placemark.number
                else {
                    throw CLError(.network)
                }
                self?.streetLocation = "\(street), \(number)"
            } catch {
                self?.streetLocation = "Location name unavailable"
            }
        }
    }
}
