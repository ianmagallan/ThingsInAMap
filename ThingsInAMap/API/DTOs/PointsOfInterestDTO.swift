//
//  PointsOfInterestDTO.swift
//  ThingsInAMap
//
//  Created by Ian Magallan on 30.12.22.
//

struct PointsOfInterestDTO: Decodable {
    let pointsOfInterest: [PointOfInterestDTO]

    enum CodingKeys: String, CodingKey {
        case pointsOfInterest
    }
}
