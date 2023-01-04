//
//  PointOfInterestRowViewModelTest.swift
//  ThingsInAMapTests
//
//  Created by Ian Magallan on 02.01.23.
//

@testable import ThingsInAMap
import Nimble
import XCTest

@MainActor
final class PointOfInterestRowViewModelTest: XCTestCase {
    func testPlacemarkReceivedSuccessfully() async {
        // given
        let mockGeocoder = MockGeocoder()
        let placemark = Stub.Entity.placemark(street: "SomeStreet", number: "SomeNumber")
        mockGeocoder.stubbedPlacermark = placemark
        let coordinate = Stub.Entity.coordinate()
	
        // when
        let sut = PointOfInterestRowViewModel(geocoder: mockGeocoder)
        await sut.fetchStreetLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

        // then
        await expect(sut.streetLocation).toEventually(equal("\(placemark.street!), \(placemark.number!)"))
    }

    func testPlacemarkError() async {
        // given
        let mockGeocoder = MockGeocoder()
        mockGeocoder.stubbedError = FNError.network
        let coordinate = Stub.Entity.coordinate()

        // when
        let sut = PointOfInterestRowViewModel(geocoder: mockGeocoder)
        await sut.fetchStreetLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

        // then
        await expect(sut.streetLocation).toEventually(equal("Location name unavailable"))
    }

    func testPlacemarkErrorDueToMissingStreet() async {
        // given
        let mockGeocoder = MockGeocoder()
        let placemark = Stub.Entity.placemark(street: nil, number: "SomeNumber")
        mockGeocoder.stubbedPlacermark = placemark
        let coordinate = Stub.Entity.coordinate()

        // when
        let sut = PointOfInterestRowViewModel(geocoder: mockGeocoder)
        await sut.fetchStreetLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

        // then
        await expect(sut.streetLocation).toEventually(equal("Location name unavailable"))
    }

    func testPlacemarkErrorDueToMissingNumber() async {
        // given
        let mockGeocoder = MockGeocoder()
        let placemark = Stub.Entity.placemark(street: "SomeStreet", number: nil)
        mockGeocoder.stubbedPlacermark = placemark
        let coordinate = Stub.Entity.coordinate()

        // when
        let sut = PointOfInterestRowViewModel(geocoder: mockGeocoder)
        await sut.fetchStreetLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

        // then
        await expect(sut.streetLocation).toEventually(equal("Location name unavailable"))
    }
}
