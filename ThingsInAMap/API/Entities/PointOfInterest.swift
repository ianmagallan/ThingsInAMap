//
//  PointOfInterest.swift
//  ThingsInAMap
//
//  Created by Ian Magallan on 30.12.22.
//

struct PointOfInterest: Identifiable {
    let id: Int
    let coordinate: Coordinate
    let state: State
    let heading: Double
}

extension PointOfInterest {
    struct Coordinate {
        let latitude: Double
        let longitude: Double
    }

    enum State {
        case active, inactive
    }
}
