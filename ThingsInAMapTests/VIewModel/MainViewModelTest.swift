//
//  MainViewModelTest.swift
//  ThingsInAMapTests
//
//  Created by Ian Magallan on 02.01.23.
//

@testable import ThingsInAMap
import Nimble
import XCTest

final class MainViewModelTest: XCTestCase {
    func testUsesDefaultCoordinatesWhenStorageHasNone() {
        // given
        let mockStorage = MockStorage()

        // when
        let sut = MainViewModel(storage: mockStorage)

        // then
        expect(sut.selectedOrigin.latitude).to(equal(53.694865))
        expect(sut.selectedOrigin.longitude).to(equal(9.757589))
        expect(sut.selectedDestination.latitude).to(equal(53.394655))
        expect(sut.selectedDestination.longitude).to(equal(10.099891))
        expect(mockStorage.invokedGetCount).to(equal(4))
    }

    func testUsesStoredCoordinates() {
        // given
        let origin = Stub.Entity.coordinate(latitude: 1, longitude: 2)
        let destination = Stub.Entity.coordinate(latitude: 3, longitude: 4)
        let mockStorage = MockStorage()
        mockStorage.stubbedGetValues[Storage.Key.p1Lat.rawValue] = origin.latitude
        mockStorage.stubbedGetValues[Storage.Key.p1Lon.rawValue] = origin.longitude
        mockStorage.stubbedGetValues[Storage.Key.p2Lat.rawValue] = destination.latitude
        mockStorage.stubbedGetValues[Storage.Key.p2Lon.rawValue] = destination.longitude

        let mockProvider = MockPointOfInterestProvider()
        mockProvider.stubbedPointsOfInterest = []

        // when
        let sut = MainViewModel(pointOfInterestProvider: mockProvider, storage: mockStorage)

        // then
        expect(sut.selectedOrigin.latitude).to(equal(origin.latitude))
        expect(sut.selectedOrigin.longitude).to(equal(origin.longitude))
        expect(sut.selectedDestination.latitude).to(equal(destination.latitude))
        expect(sut.selectedDestination.longitude).to(equal(destination.longitude))
        expect(mockStorage.invokedGetCount).to(equal(4))
    }

    func testUpdatesCoordinatesValueInStorage() {
        // given
        let mockStorage = MockStorage()
        let mockProvider = MockPointOfInterestProvider()
        mockProvider.stubbedPointsOfInterest = []

        // when
        let sut = MainViewModel(pointOfInterestProvider: mockProvider, storage: mockStorage)
        sut.selectedOrigin.latitude = -1
        sut.selectedOrigin.longitude = -2
        sut.selectedDestination.latitude = -3
        sut.selectedDestination.longitude = -4

        // then
        expect(mockStorage.stubbedSetValues[Storage.Key.p1Lat.rawValue]).to(equal(-1))
        expect(mockStorage.stubbedSetValues[Storage.Key.p1Lon.rawValue]).to(equal(-2))
        expect(mockStorage.stubbedSetValues[Storage.Key.p2Lat.rawValue]).to(equal(-3))
        expect(mockStorage.stubbedSetValues[Storage.Key.p2Lon.rawValue]).to(equal(-4))
    }

    func testSaveActionTriggersFetchingFromServer() {
        // given
        let mockStorage = MockStorage()
        let mockProvider = MockPointOfInterestProvider()
        mockProvider.stubbedPointsOfInterest = []

        // when
        let sut = MainViewModel(pointOfInterestProvider: mockProvider, storage: mockStorage)
        sut.saveAction.send()

        // then
        expect(mockProvider.invokedFetchPointsOfInterestCount).to(equal(1))
    }

    func testFetchPointsOfInterestSuccess() {
        // given
        let mockStorage = MockStorage()
        let mockProvider = MockPointOfInterestProvider()
        let pointOfInterest = Stub.Entity.pointOfInterest()
        mockProvider.stubbedPointsOfInterest = [pointOfInterest]

        // when
        let sut = MainViewModel(pointOfInterestProvider: mockProvider, storage: mockStorage)
        sut.fetchPointsOfInterest()

        // then
        expect(sut.pointsOfInterest).to(haveCount(1))
        expect(sut.pointsOfInterest[0].id).to(equal(pointOfInterest.id))
        expect(sut.pointsOfInterest[0].coordinate.latitude).to(equal(pointOfInterest.coordinate.latitude))
        expect(sut.pointsOfInterest[0].coordinate.longitude).to(equal(pointOfInterest.coordinate.longitude))
        expect(sut.pointsOfInterest[0].state).to(equal(.active))
        expect(sut.pointsOfInterest[0].heading).to(equal(pointOfInterest.heading))
        expect(sut.isLoading).to(beFalse())
        expect(mockProvider.invokedFetchPointsOfInterestCount).to(equal(1))
    }

    func testFetchPointsOfInterestFailure() {
        // given
        let mockStorage = MockStorage()
        let mockProvider = MockPointOfInterestProvider()
        mockProvider.stubbedError = .network

        // when
        let sut = MainViewModel(pointOfInterestProvider: mockProvider, storage: mockStorage)
        sut.fetchPointsOfInterest()

        // then
        expect(mockProvider.invokedFetchPointsOfInterestCount).to(equal(1))
        expect(sut.isLoading).to(beFalse())
    }
}
