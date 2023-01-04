//
//  PointOfInterestProvider.swift
//  ThingsInAMap
//
//  Created by Ian Magallan on 30.12.22.
//

import Combine

protocol PointOfInterestProviding {
    func fetchPointsOfInterest(p1Lat: Double, p1Lon: Double, p2Lat: Double, p2Lon: Double) -> AnyPublisher<[PointOfInterest], FNError>
}

final class PointOfInterestProvider: PointOfInterestProviding {
    private let requestFactory: RequestFactoring
    private let httpExecutor: HttpExecuting

    init(
        requestFactory: RequestFactoring = RequestFactory(),
        httpExecutor: HttpExecuting = HttpExecutor()
    ) {
        self.requestFactory = requestFactory
        self.httpExecutor = httpExecutor
    }

    func fetchPointsOfInterest(p1Lat: Double, p1Lon: Double, p2Lat: Double, p2Lon: Double) -> AnyPublisher<[PointOfInterest], FNError> {
        let path = "?p2Latitude=\(p2Lat)&p1Longitude=\(p1Lon)&p1Latitude=\(p1Lat)&p2Longitude=\(p2Lon)"

        return httpExecutor.execute(
            request: requestFactory.fetchPointsOfInterest(path: path)
        )
        .map(PointOfInterestConverter.pointsOfInterest)
        .eraseToAnyPublisher()
    }
}
