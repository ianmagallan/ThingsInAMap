//
//  PointOfInterestDTO.swift
//  ThingsInAMap
//
//  Created by Ian Magallan on 30.12.22.
//

struct PointOfInterestDTO: Decodable {
    let id: Int
    let coordinate: CoordinateDTO
    let state: State
    let heading: Double
}

extension PointOfInterestDTO {
    enum State: String, Decodable {
        case active = "ACTIVE"
        case inactive = "INACTIVE"
    }
}
