//
//  PointOfInterestProviderTest.swift
//  ThingsInAMapTests
//
//  Created by Ian Magallan on 01.01.23.
//

import Combine
@testable import ThingsInAMap
import Nimble
import XCTest

final class PointOfInterestProviderTest: XCTestCase {
    func testProviderValueWhenSuccessful() {
        // given
        let coordinate = Stub.Entity.coordinate()
        let mockHttpExecutor = MockHttpExecutor()
        mockHttpExecutor.stubbedData = Stub.data
        var pointsOfInterest: [PointOfInterest]?

        // when
        let sut = PointOfInterestProvider(httpExecutor: mockHttpExecutor)
        let _ = sut.fetchPointsOfInterest(
            p1Lat: coordinate.latitude,
            p1Lon: coordinate.longitude,
            p2Lat: coordinate.latitude,
            p2Lon: coordinate.longitude
        )
        .sink { _ in } receiveValue: { pointsOfInterest = $0 }

        // then
        expect(pointsOfInterest).toNotEventually(beNil())
    }

    func testProviderValueWhenError() {
        // given
        let coordinate = Stub.Entity.coordinate()
        let mockHttpExecutor = MockHttpExecutor()
        mockHttpExecutor.stubbedError = .parsing
        var expectedError: FNError?

        // when
        let sut = PointOfInterestProvider(httpExecutor: mockHttpExecutor)
        let _ = sut.fetchPointsOfInterest(
            p1Lat: coordinate.latitude,
            p1Lon: coordinate.longitude,
            p2Lat: coordinate.latitude,
            p2Lon: coordinate.longitude
        )
        .sink { result in
            guard case let .failure(error) = result else {
                return
            }
            expectedError = error
        } receiveValue: { _ in }

        // then
        expect(expectedError).toNotEventually(beNil())
    }
}
