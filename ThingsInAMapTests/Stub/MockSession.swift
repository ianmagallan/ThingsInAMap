//
//  MockSession.swift
//  ThingsInAMapTests
//
//  Created by Ian Magallan on 30.12.22.
//

import Combine
import Foundation
@testable import ThingsInAMap

final class MockSession: Sessioning {
    let mockData: Data
    let mockResponse: URLResponse

    init(mockData: Data, mockResponse: URLResponse) {
        self.mockData = mockData
        self.mockResponse = mockResponse
    }

    func dataTaskPublisher(for _: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), Error> {
        Result.success((mockData, mockResponse)).publisher
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
