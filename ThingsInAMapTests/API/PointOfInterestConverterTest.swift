//
//  PointOfInterestConverterTest.swift
//  ThingsInAMapTests
//
//  Created by Ian Magallan on 01.01.23.
//

@testable import ThingsInAMap
import Nimble
import XCTest

final class PointOfInterestConverterTest: XCTestCase {
    typealias Sut = PointOfInterestConverter

    func testPointOfInterestConverter() {
        // given
        let coordinateDTO = Stub.DTO.coordinate(latitude: 10, longitude: 11)
        let pointOfInterestDTO = Stub.DTO.pointOfInterest(
            id: -1,
            coordinate: coordinateDTO,
            state: .inactive,
            heading: 1.234
        )
        let pointsOfInterestDTO = Stub.DTO.pointsOfInterest(pointsOfInterest: [pointOfInterestDTO])

        // when
        let pointsOfInterest = Sut.pointsOfInterest(pointsOfInterestDTO)

        // then
        expect(pointsOfInterest).to(haveCount(1))
        expect(pointsOfInterest[0].id).to(equal(pointOfInterestDTO.id))
        expect(pointsOfInterest[0].coordinate.latitude).to(equal(coordinateDTO.latitude))
        expect(pointsOfInterest[0].coordinate.longitude).to(equal(coordinateDTO.longitude))
        expect(pointsOfInterest[0].state).to(equal(.inactive))
        expect(pointsOfInterest[0].heading).to(equal(pointOfInterestDTO.heading))
    }
}
