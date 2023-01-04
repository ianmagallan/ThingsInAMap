//
//  Session.swift
//  ThingsInAMap
//
//  Created by Ian Magallan on 30.12.22.
//

import Combine
import Foundation

protocol Sessioning {
    func dataTaskPublisher(for request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), Error>
}

struct Session: Sessioning {
    func dataTaskPublisher(for request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), Error> {
        URLSession.shared
            .dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .map { (data: $0.data, response: $0.response) }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
