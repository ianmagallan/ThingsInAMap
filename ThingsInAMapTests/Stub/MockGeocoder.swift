//
//  MockGeocoder.swift
//  ThingsInAMapTests
//
//  Created by Ian Magallan on 02.01.23.
//

import CoreLocation
@testable import ThingsInAMap

final class MockGeocoder: Geocoding {
    var stubbedPlacermark: Placemark?
    var stubbedError: FNError?
    func reverseGeocodeLocation(_: CLLocation) async throws -> Placemark {
        if let stubbedPlacermark {
            return stubbedPlacermark
        } else if let stubbedError {
            throw stubbedError
        } else {
            fatalError("Either data or error need to be set")
        }
    }
}
