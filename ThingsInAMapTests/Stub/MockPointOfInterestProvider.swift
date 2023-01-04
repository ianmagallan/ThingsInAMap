//
//  MockPointOfInterestProvider.swift
//  ThingsInAMapTests
//
//  Created by Ian Magallan on 02.01.23.
//

import Combine
import Foundation
@testable import ThingsInAMap

final class MockPointOfInterestProvider: PointOfInterestProviding {
    var stubbedPointsOfInterest: [PointOfInterest]?
    var stubbedError: FNError?
    var invokedFetchPointsOfInterestCount = 0

    func fetchPointsOfInterest(
        p1Lat _: Double,
        p1Lon _: Double,
        p2Lat _: Double,
        p2Lon _: Double
    ) -> AnyPublisher<[PointOfInterest], FNError> {
        invokedFetchPointsOfInterestCount += 1
        if let stubbedPointsOfInterest {
            return Result.success(stubbedPointsOfInterest).publisher.eraseToAnyPublisher()
        } else if let stubbedError {
            return Result.failure(stubbedError).publisher.eraseToAnyPublisher()
        } else {
            fatalError("Either data or error need to be set")
        }
    }
}
