//
//  Stub.swift
//  ThingsInAMapTests
//
//  Created by Ian Magallan on 30.12.22.
//

import Foundation
@testable import ThingsInAMap

enum Stub {
    private static let pointsOfInterestString = """
    {
        "pointsOfInterest": [{
            "id": -1074560514,
            "coordinate": {
                "latitude": 53.585327662420966,
                "longitude": 9.932289384305477
            },
            "state": "ACTIVE",
            "heading": 340.7272033691406
        }]
    }
    """
    static let url = URL(string: "https://www.google.com")!
    static let data = pointsOfInterestString.data(using: .utf8)!
    static let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!

    enum DTO {
        static func pointsOfInterest(
            pointsOfInterest: [PointOfInterestDTO] = [pointOfInterest()]
        ) -> PointsOfInterestDTO {
            .init(pointsOfInterest: pointsOfInterest)
        }

        static func pointOfInterest(
            id: Int = 1,
            coordinate: CoordinateDTO = coordinate(),
            state: PointOfInterestDTO.State = .active,
            heading: Double = 360
        ) -> PointOfInterestDTO {
            .init(
                id: id,
                coordinate: coordinate,
                state: state,
                heading: heading
            )
        }

        static func coordinate(
            latitude: Double = 1,
            longitude: Double = 2
        ) -> CoordinateDTO {
            .init(latitude: latitude, longitude: longitude)
        }
    }

    enum Entity {
        static func pointOfInterest(
            id: Int = 1,
            coordinate: PointOfInterest.Coordinate = coordinate(),
            state: PointOfInterest.State = .active,
            heading: Double = 2
        ) -> PointOfInterest {
            .init(
                id: id,
                coordinate: coordinate,
                state: state,
                heading: heading
            )
        }

        static func coordinate(
            latitude: Double = 1,
            longitude: Double = 2
        ) -> PointOfInterest.Coordinate {
            .init(latitude: latitude, longitude: longitude)
        }

        static func placemark(
            street: String? = nil,
            number: String? = nil
        ) -> Placemark {
            .init(street: street, number: number)
        }
    }
}
