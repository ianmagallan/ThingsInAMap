//
//  PointOfInterestConverter.swift
//  ThingsInAMap
//
//  Created by Ian Magallan on 30.12.22.
//

enum PointOfInterestConverter {
    static func pointsOfInterest(_ pointsOfInterest: PointsOfInterestDTO) -> [PointOfInterest] {
        pointsOfInterest.pointsOfInterest.map(pointOfInterest)
    }

    private static func pointOfInterest(_ pointOfInterest: PointOfInterestDTO) -> PointOfInterest {
        .init(
            id: pointOfInterest.id,
            coordinate: coordinate(pointOfInterest.coordinate),
            state: state(pointOfInterest.state),
            heading: pointOfInterest.heading
        )
    }

    private static func coordinate(_ coordinate: CoordinateDTO) -> PointOfInterest.Coordinate {
        .init(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }

    private static func state(_ state: PointOfInterestDTO.State) -> PointOfInterest.State {
        switch state {
        case .active:
            return .active
        case .inactive:
            return .inactive
        }
    }
}
