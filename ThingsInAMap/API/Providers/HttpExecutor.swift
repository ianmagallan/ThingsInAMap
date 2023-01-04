//
//  HttpExecutor.swift
//  ThingsInAMap
//
//  Created by Ian Magallan on 30.12.22.
//

import Combine
import Foundation

enum FNError: Error {
    case unknown(error: Error)
    case network
    case parsing
}

extension FNError: Equatable {
    static func == (lhs: FNError, rhs: FNError) -> Bool {
        switch (lhs, rhs) {
        case (.unknown, .unknown):
            return true
        case (.network, .network):
            return true
        case (.parsing, .parsing):
            return true
        default:
            return false
        }
    }
}

protocol HttpExecuting {
    func execute<T: Decodable>(request: URLRequest) -> AnyPublisher<T, FNError>
}

final class HttpExecutor: HttpExecuting {
    let session: Sessioning

    init(session: Sessioning = Session()) {
        self.session = session
    }

    func execute<T: Decodable>(request: URLRequest) -> AnyPublisher<T, FNError> {
        session.dataTaskPublisher(for: request)
            .tryMap { data, response -> T in
                guard let response = response as? HTTPURLResponse,
                      (200 ..< 300).contains(response.statusCode)
                else {
                    throw FNError.network
                }

                do {
                    return try JSONDecoder().decode(T.self, from: data)
                } catch {
                    throw FNError.parsing
                }
            }
            .mapError { error -> FNError in
                guard let error = error as? FNError else {
                    return .unknown(error: error)
                }
                return error
            }
            .eraseToAnyPublisher()
    }
}
